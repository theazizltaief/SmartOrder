class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      total_commandes: Commande.count,
      commandes_en_attente: Commande.where(statut: "en_attente").count,
      commandes_en_preparation: Commande.where(statut: "en_preparation").count,
      commandes_prete: Commande.where(statut: "prete").count,
      commandes_servie: Commande.where(statut: "servie").count,
      total_plats: Plat.count,
      chiffre_affaires_jour: calculate_daily_revenue
    }

    # Chargement des commandes récentes avec les associations
    @recent_commandes = Commande.includes(:table, ligne_commandes: :plat)
                               .order(created_at: :desc)
                               .limit(5)
  end

  private

  def calculate_daily_revenue
    today_orders = Commande.where(created_at: Date.current.beginning_of_day..Date.current.end_of_day)
    total = 0
    today_orders.each do |commande|
      total += commande.ligne_commandes.sum { |lc| lc.plat.prix_en_centimes * lc.quantite }
    end
    total / 100.0 # Convertir en dinars
  end
end
