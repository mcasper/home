Rails.application.routes.draw do
  scope "scoreboard-backend" do
    post "/graphql", to: "graphql#execute"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
