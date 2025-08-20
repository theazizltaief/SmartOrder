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

    # 5️⃣ Sauvegarde et broadcast
    if commande.save
      Rails.logger.info "🍽️ [Commande] Nouvelle commande créée: #{commande.id}"

      # ✅ Broadcast vers Electron via OrdersChannel
      # IMPORTANT: Utiliser "orders_stream" (même nom que dans OrdersChannel)
      broadcast_data = {
        order_id: "CMD-#{commande.id}",
        table_number: commande.table&.numero || "?",
        created_at: commande.created_at.iso8601,
        currency: "TND",
        notes: commande.remarque_generale,
        items: commande.ligne_commandes.map do |lc|
          {
            name: lc.plat.nom,
            qty: lc.quantite,
            category: lc.plat.type_de_plat,  # "boisson", "plat", "dessert", etc.
            unit_price_cents: lc.plat.prix_en_centimes,
            notes: lc.remarque,
            sauces: lc.sauces || [],
            legumes: lc.legumes || [],
            supplements: lc.supplements || []
          }
        end,
        # Données pour le reçu final
        receipt: {
          order_id: "CMD-#{commande.id}",
          table_number: commande.table&.numero || "?",
          total: commande.ligne_commandes.sum { |lc| lc.quantite * lc.plat.prix_en_centimes },
          currency: "TND",
          lines: commande.ligne_commandes.map do |lc|
            {
              name: lc.plat.nom,
              qty: lc.quantite,
              unit_price_cents: lc.plat.prix_en_centimes,
              total_cents: lc.quantite * lc.plat.prix_en_centimes
            }
          end
        }
      }

      Rails.logger.info "📡 [Broadcast] Envoi vers 'orders_stream': #{broadcast_data[:order_id]}"
      ActionCable.server.broadcast("orders_stream", broadcast_data)

      redirect_to menu_path, notice: "✅ Votre commande a été envoyée à la cuisine !"
    else
      redirect_to menu_path, alert: "❌ Échec : #{commande.errors.full_messages.join(', ')}"
    end
  end

  def show
    @commande = Commande.find(params[:id])
  end
end
