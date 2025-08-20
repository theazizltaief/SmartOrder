class DebugController < ApplicationController
  before_action :authenticate_admin_user!

  def session_info
    session_data = {
      current_admin_user_id: current_admin_user&.id,
      current_admin_user_email: current_admin_user&.email,
      session_keys: session.keys,
      cookie_keys: cookies.to_h.keys,
      warden_user: warden.user(:admin_user)&.email,
      session_warden_key: session["warden.user.admin_user.key"]
    }

    render json: session_data, status: :ok
  end

  private

  def authenticate_admin_user!
    redirect_to new_admin_user_session_path unless admin_user_signed_in?
  end
end
