class Admin::BaseController < ApplicationController
  # Protéger toutes les routes admin avec AdminUser
  before_action :authenticate_admin_user!

  # Layout spécifique pour l'admin - IMPORTANT !
  layout "admin"

  private

  def authenticate_admin_user!
    unless admin_user_signed_in?
      redirect_to new_admin_user_session_path, alert: "Vous devez vous connecter pour accéder à cette page."
    end
  end
end
