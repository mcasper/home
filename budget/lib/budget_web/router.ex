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

    get("/", BudgetController, :show)
    post("/plaid/exchange", PlaidExchangeController, :create)
  end
end
