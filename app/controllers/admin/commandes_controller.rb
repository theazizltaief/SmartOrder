class Admin::CommandesController < Admin::BaseController
  before_action :set_commande, only: [ :show, :update, :destroy ]

  def index
    @commandes = Commande.includes(:table, ligne_commandes: :plat)

    # Filtrage par statut si paramètre présent
    if params[:statut].present?
      @commandes = @commandes.where(statut: params[:statut])
    end

    @commandes = @commandes.order(created_at: :desc)
  end

  def show
    # @commande est déjà défini par le before_action
  end

  def new
    @commande = Commande.new
    @commande.ligne_commandes.build  # Pour afficher au moins une ligne dans le formulaire
    @plats = Plat.all.order(:nom)
    @tables = Table.all.order(:numero)
  end

  def create
    @commande = Commande.new(commande_params_for_create)
    @commande.statut = "en_attente"

    if @commande.save
      Rails.logger.info "🍽️ [Admin] Nouvelle commande créée: #{@commande.id}"

      # Même broadcast que la vitrine pour notifier Electron
      broadcast_data = {
        order_id: "CMD-#{@commande.id}",
        table_number: @commande.table&.numero || "?",
        created_at: @commande.created_at.iso8601,
        currency: "TND",
        notes: @commande.remarque_generale,
        items: @commande.ligne_commandes.map do |lc|
          {
            name: lc.plat.nom,
            qty: lc.quantite,
            category: lc.plat.type_de_plat,
            unit_price_cents: lc.plat.prix_en_centimes,
            notes: lc.remarque,
            sauces: lc.sauces || [],
            legumes: lc.legumes || [],
            supplements: lc.supplements || []
          }
        end,
        receipt: {
          order_id: "CMD-#{@commande.id}",
          table_number: @commande.table&.numero || "?",
          total: @commande.ligne_commandes.sum { |lc| lc.quantite * lc.plat.prix_en_centimes },
          currency: "TND",
          lines: @commande.ligne_commandes.map do |lc|
            {
              name: lc.plat.nom,
              qty: lc.quantite,
              unit_price_cents: lc.plat.prix_en_centimes,
              total_cents: lc.quantite * lc.plat.prix_en_centimes
            }
          end
        }
      }

      Rails.logger.info "📡 [Admin Broadcast] Envoi vers 'orders_stream': #{broadcast_data[:order_id]}"
      ActionCable.server.broadcast("orders_stream", broadcast_data)

      redirect_to admin_commandes_path, notice: "✅ Commande créée avec succès !"
    else
      @plats = Plat.all.order(:nom)
      @tables = Table.all.order(:numero)
      flash.now[:alert] = "❌ Erreur lors de la création: #{@commande.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @commande.update(commande_params)
      redirect_to admin_commandes_path,
                  notice: "✅ Statut de la commande ##{@commande.id} mis à jour vers '#{@commande.statut.humanize}'"
    else
      redirect_to admin_commandes_path,
                  alert: "❌ Erreur lors de la mise à jour du statut"
    end
  end

  def destroy
    if @commande.destroy
      redirect_to admin_commandes_path,
                  notice: "🗑️ Commande ##{@commande.id} supprimée avec succès"
    else
      redirect_to admin_commandes_path,
                  alert: "❌ Erreur lors de la suppression de la commande"
    end
  end

  private

  def set_commande
    @commande = Commande.includes(:table, ligne_commandes: :plat).find(params[:id])
  end

  def commande_params
    params.require(:commande).permit(:statut)
  end

  def commande_params_for_create
    params.require(:commande).permit(
      :table_id,
      :remarque_generale,
      ligne_commandes_attributes: [
        :plat_id,
        :quantite,
        :remarque,
        :sauces_text,
        :legumes_text,
        :supplements_text,
        :_destroy
      ]
    )
  end
end
