defmodule BudgetWeb.PlaidExchangeController do
  use BudgetWeb, :controller

  def create(conn, %{"public_token" => public_token}) do
    case Budget.Plaid.exchange_token(public_token) do
      {:ok, public_token_response} ->
        {:ok, _transactions} =
          Budget.Plaid.get_transactions(public_token_response["access_token"])

        {:ok, _balances} = Budget.Plaid.get_balances(public_token_response["access_token"])

        conn
        |> put_flash(:info, "Hooked up your bank account")
        |> redirect(to: Routes.budget_path(conn, :show))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error hooking up your bank account")
        |> redirect(to: Routes.budget_path(conn, :show))
    end
  end
end
