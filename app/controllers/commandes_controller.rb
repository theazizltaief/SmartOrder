class CommandesController < ApplicationController
  def create
    ligne_commandes = params[:commande][:ligne_commandes_attributes]

    puts "====== PARAMS REÇUS ======"
    pp params[:commande]

    if ligne_commandes.blank?
      redirect_to menu_path, alert: "❌ Votre panier est vide."
      return
    end

    commande = Commande.new(
      table_id: params[:commande][:table_id],
      statut: "en_attente",
      ligne_commandes_attributes: JSON.parse(ligne_commandes)
    )

    if commande.save
      # Optionnel : Broadcast pour ActionCable (si vous l'ajoutez plus tard)
      # ActionCable.server.broadcast("commandes_channel", {
      #   action: "nouvelle_commande",
      #   commande: commande.as_json(include: { ligne_commandes: { include: :plat } })
      # })

      redirect_to menu_path, notice: "✅ Votre commande a été envoyée à la cuisine !"
    else
      puts "====== ERREURS ======"
      pp commande.errors.full_messages
      redirect_to menu_path, alert: "❌ Échec de l'envoi de la commande"
    end
  end

  def show
    @commande = Commande.find(params[:id])
  end
end
