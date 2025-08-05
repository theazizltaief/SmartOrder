class CommandesController < ApplicationController
def create
  ligne_commandes = params[:commande][:ligne_commandes_attributes]

  puts "====== PARAMS REÇUS ======"
  pp params[:commande]

  if ligne_commandes.blank?
    redirect_to menu_path, alert: "Votre panier est vide."
    return
  end

  commande = Commande.new(
    table_id: params[:commande][:table_id],
    statut: "en_attente",
    ligne_commandes_attributes: JSON.parse(ligne_commandes)
  )

  if commande.save
    redirect_to menu_path, notice: "✅ Commande enregistrée"
  else
    puts "====== ERREURS ======"
    pp commande.errors.full_messages
    redirect_to menu_path, alert: "❌ Échec"
  end
end
end
