Rails.application.routes.draw do
  root "recipes#index"

  get "/recipes", to: "recipes#index", as: :recipes_root

  scope :recipes do
    resources :recipes, only: [:index, :new, :create]
  end
end
