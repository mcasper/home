Rails.application.routes.draw do
  root "recipes#index"

  get "/recipes", to: "recipes#index", as: :recipes_root
  get "/health", to: "health#show"

  scope :recipes do
    resources :recipes, only: [:index, :new, :create, :show]
  end
end
