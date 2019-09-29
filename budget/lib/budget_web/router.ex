defmodule BudgetWeb.Router do
  use BudgetWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :browser_auth do
    plug(BudgetWeb.AuthPlug)
  end

  pipeline :graphql_auth do
    plug(:fetch_session)
    plug(BudgetWeb.GraphqlAuthPlug)
  end

  scope "/budget-backend" do
    pipe_through(:graphql_auth)

    forward "/graphql", Absinthe.Plug, schema: BudgetWeb.Graphql.Schema
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BudgetWeb.Graphql.Schema
  end

  scope "/", BudgetWeb do
    pipe_through(:browser)
    get("/health", HealthController, :index)
  end

  scope "/budget", BudgetWeb do
    pipe_through(:browser)
    pipe_through(:browser_auth)

    get("/", GoalController, :show)

    get("/accounts", AccountController, :index)
    get("/accounts/:id", AccountController, :show)
    get("/plaid/items/new", PlaidItemController, :new)
    post("/plaid/items", PlaidItemController, :create)

    get("/spend", SpendController, :index)
    get("/spend/categorize", CategorizeSpendController, :index)

    get("/goal", GoalController, :show)
    get("/goal/edit", GoalController, :edit)
    put("/goal", GoalController, :update)
    resources("/goals", GoalController, only: [:new, :create])

    resources("/ignored_transactions", PlaidIgnoredTransactionController, only: [:create])
    resources("/categorized_transactions", PlaidCategorizedTransactionController, only: [:create])
  end
end
