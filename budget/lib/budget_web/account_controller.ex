defmodule BudgetWeb.AccountController do
  use BudgetWeb, :controller

  def index(conn, _params) do
    current_user = current_user(conn) |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        redirect(conn, to: Routes.plaid_item_path(conn, :new))

      item ->
        render(conn, :index)
    end
  end

  defp current_user(conn) do
    Budget.Accounts.get_user!(conn.assigns[:user_id])
  end
end
