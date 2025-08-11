class ApplicationController < ActionController::Base
  # Protect from forgery attacks
  protect_from_forgery with: :exception

  # Configuration Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Redirection après connexion admin
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path  # Rediriger vers /admin après connexion
    else
      root_path
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :email ])
  end
end
