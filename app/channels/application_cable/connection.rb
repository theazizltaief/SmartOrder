module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_admin

    def connect
      self.current_admin = "test_admin_#{rand(1000)}"
      Rails.logger.info "🔓 [ActionCable] Connexion SANS AUTH acceptée: #{current_admin}"
    end
  end
end
