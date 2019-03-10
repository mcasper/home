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

    get("/", AccountController, :index)
    get("/accounts", AccountController, :index)
    get("/accounts/:id", AccountController, :show)
    get("/plaid/items/new", PlaidItemController, :new)
    post("/plaid/items", PlaidItemController, :create)

    get("/spend", SpendController, :index)
    resources("/goals", GoalController, only: [:new, :create, :show])
  end
end
