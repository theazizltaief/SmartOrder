Rails.application.routes.draw do
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

  # Interface admin protégée
  namespace :admin do
    root "dashboard#index"  # Cette ligne était manquante !
    resources :plats
    resources :commandes, only: [ :index, :show, :update ] do
      collection do
        get :filter, path: "/", action: :index
      end
    end
  end
end
