class Admin::SessionsController < Admin::BaseController
  # On ignore l’authentification Devise pour cette action
  skip_before_action :authenticate_admin_user!

  # GET /admin/auto_login/:id
  def auto_login
    admin = AdminUser.find_by(id: params[:id])

    if admin
      # Connecte l’admin via Devise
      sign_in(admin)

      # Retourne la valeur du cookie de session Devise
      render json: { success: true, cookie_name: "_smartorder_admin_user_session", cookie_value: cookies["_smartorder_admin_user_session"] }
    else
      render json: { success: false, error: "Admin non trouvé" }, status: :not_found
    end
  end
end
