Rails.application.routes.draw do
   mount ActionCable.server => "/cable"
  # Devise pour les admins
  devise_for :admin_users, path: "admin", path_names: {
    sign_in: "login",
    sign_out: "logout"
  }

  # Page d'accueil - Interface client (vitrine des plats)
  root "menu#index"

  # Interface client publique
  get "/menu", to: "menu#index"
  resources :commandes, only: [ :create, :show ]
  # Route pour le debug
  get "/debug/session", to: "debug#session_info"
  # Route pour auto-login admin (pour Electron / dev uniquement)
  namespace :admin do
    get "auto_login/:id", to: "sessions#auto_login"
  end

  # Interface admin protégée
  namespace :admin do
    root "dashboard#index"
    resources :plats
    resources :commandes do
      collection do
        get :filter, path: "/", action: :index
      end
    end
  end
end
