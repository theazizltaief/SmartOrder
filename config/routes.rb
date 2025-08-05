Rails.application.routes.draw do
  get "commandes/create"
  get "commandes/show"
  get "menu/index"
  root "menu#index"

  # Interface client
  get "/menu", to: "menu#index"
  resources :commandes, only: [ :create, :show ]

  # Interface admin
  namespace :admin do
    get "commandes/index"
    get "commandes/show"
    get "commandes/update"
    resources :plats
    resources :commandes, only: [ :index, :show, :update ]
  end
end
