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
  params.require(:commande).permit(
    :statut,
    :table_id,
    :remarque_generale,
    ligne_commandes_attributes: [ :plat_id, :quantite, :remarque, :sauces, :legumes, :supplements ]
  )
end
end
