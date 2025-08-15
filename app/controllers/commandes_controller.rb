class CommandesController < ApplicationController
  def create
    # 1️⃣ Récupérer les lignes de commande JSON
    ligne_commandes = JSON.parse(params[:commande][:ligne_commandes_attributes] || "[]")

    # 2️⃣ Vérifier si le panier est vide
    if ligne_commandes.empty?
      redirect_to menu_path, alert: "❌ Votre panier est vide."
      return
    end

    # 3️⃣ S'assurer que sauces, legumes et supplements sont toujours des tableaux
    ligne_commandes = ligne_commandes.map do |lc|
      lc["sauces"]      ||= []
      lc["legumes"]     ||= []
      lc["supplements"] ||= []
      lc
    end

    # 4️⃣ Créer la commande
    commande = Commande.new(
      table_id: params[:commande][:table_id],
      statut: "en_attente",
      ligne_commandes_attributes: ligne_commandes
    )

    # 5️⃣ Sauvegarde et retour côté client
    if commande.save
      redirect_to menu_path, notice: "✅ Votre commande a été envoyée à la cuisine !"
    else
      redirect_to menu_path, alert: "❌ Échec : #{commande.errors.full_messages.join(', ')}"
    end
  end

  def show
    @commande = Commande.find(params[:id])
  end
end
