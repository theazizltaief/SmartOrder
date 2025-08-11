class Admin::PlatsController < Admin::BaseController
  before_action :set_plat, only: [ :show, :edit, :update, :destroy ]

  def index
    @plats = Plat.all.order(:nom)
  end

  def show
    # @plat est défini par le before_action
  end

  def new
    @plat = Plat.new
  end

  def create
    @plat = Plat.new(plat_params)

    if @plat.save
      redirect_to admin_plat_path(@plat), notice: "✅ Plat créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @plat est défini par le before_action
  end

  def update
    if @plat.update(plat_params)
      redirect_to admin_plat_path(@plat), notice: "✅ Plat mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    nom_plat = @plat.nom

    begin
      # Vérifier s'il y a des commandes liées
      if @plat.ligne_commandes.exists?
        redirect_to admin_plats_path,
                    alert: "❌ Impossible de supprimer '#{nom_plat}' car il est utilisé dans des commandes."
        return
      end

      @plat.destroy!
      redirect_to admin_plats_path,
                  notice: "✅ Le plat '#{nom_plat}' a été supprimé avec succès."
    rescue => e
      Rails.logger.error "Erreur lors de la suppression du plat #{@plat.id}: #{e.message}"
      redirect_to admin_plats_path,
                  alert: "❌ Erreur lors de la suppression : #{e.message}"
    end
  end

  private

  def set_plat
    @plat = Plat.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_plats_path, alert: "❌ Plat introuvable."
  end

  def plat_params
    params.require(:plat).permit(:nom, :description, :prix_en_centimes, :type_de_plat, :photo)
  end
end
