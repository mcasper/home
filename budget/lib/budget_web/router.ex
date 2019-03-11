defmodule BudgetWeb.Router do
  use BudgetWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BudgetWeb.AuthPlug)
  end

  scope "/budget", BudgetWeb do
    pipe_through :browser

    get("/", GoalController, :show)

    get("/accounts", AccountController, :index)
    get("/accounts/:id", AccountController, :show)
    get("/plaid/items/new", PlaidItemController, :new)
    post("/plaid/items", PlaidItemController, :create)

    get("/spend", SpendController, :index)

    get("/goal", GoalController, :show)
    get("/goal/edit", GoalController, :edit)
    put("/goal", GoalController, :update)
    resources("/goals", GoalController, only: [:new, :create])

    resources("/ignored_transactions", PlaidIgnoredTransactionController, only: [:create])
  end
end
