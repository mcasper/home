defmodule BudgetWeb.AccountController do
  use BudgetWeb, :controller

  def index(conn, _params) do
    current_user = current_user(conn) |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        redirect(conn, to: Routes.plaid_item_path(conn, :new))

      item ->
        {:ok, %{"accounts" => balances}} = Budget.Plaid.Client.get_balances(item.access_token)
        render(conn, :index, balances: balances)
    end
  end

  def show(conn, %{"id" => account_id}) do
    current_user = current_user(conn) |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        redirect(conn, to: Routes.plaid_item_path(conn, :new))

      item ->
        {:ok, %{"transactions" => transactions}} =
          Budget.Plaid.Client.get_transactions(item.access_token, account_id)

        render(conn, :show, transactions: transactions)
    end
  end

  defp current_user(conn) do
    Budget.Accounts.get_user!(conn.assigns[:user_id])
  end
end
