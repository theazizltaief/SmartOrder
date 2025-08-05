class Admin::CommandesController < ApplicationController
  before_action :set_commande, only: [ :show, :update ]

def create
  ligne_commandes = params[:commande][:ligne_commandes_attributes]

  if ligne_commandes.blank?
    redirect_to menu_path, alert: "Votre panier est vide."
    return
  end

  puts "====> PARAMS REÇUS"
  puts params[:commande].inspect
  puts ligne_commandes

  commande = Commande.new(
    table_id: params[:commande][:table_id],
    statut: "en_attente",
    ligne_commandes_attributes: JSON.parse(ligne_commandes)
  )

  if commande.save
    redirect_to menu_path, notice: "✅ Votre commande a été envoyée à la cuisine !"
  else
    puts "ERREURS DE SAUVEGARDE : #{commande.errors.full_messages}"
    redirect_to menu_path, alert: "❌ Échec de la commande"
  end
end

  def index
    @commandes = Commande.includes(ligne_commandes: :plat).order(created_at: :desc)
  end

  def show; end

  def update
    if @commande.update(commande_params)
      redirect_to admin_commandes_path, notice: "Statut mis à jour."
    else
      redirect_to admin_commandes_path, alert: "Échec de la mise à jour."
    end
  end

  private

  def set_commande
    @commande = Commande.find(params[:id])
  end

  def commande_params
    params.require(:commande).permit(:statut)
  end
end
