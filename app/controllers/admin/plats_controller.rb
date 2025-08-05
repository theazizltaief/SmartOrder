class Admin::PlatsController < ApplicationController
before_action :set_plat, only: [ :edit, :update, :destroy ]

  def index
    @plats = Plat.all
  end

  def new
    @plat = Plat.new
  end

  def create
    @plat = Plat.new(plat_params)
    if @plat.save
      redirect_to admin_plats_path, notice: "Plat créé avec succès."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @plat.update(plat_params)
      redirect_to admin_plats_path, notice: "Plat mis à jour."
    else
      render :edit
    end
  end

  def destroy
    @plat.destroy
    redirect_to admin_plats_path, notice: "Plat supprimé."
  end

  private

  def set_plat
    @plat = Plat.find(params[:id])
  end

  def plat_params
    params.require(:plat).permit(:nom, :description, :prix_en_centimes, :type_de_plat, :photo)
  end
end
