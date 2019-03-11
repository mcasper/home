defmodule BudgetWeb.HasItemPlug do
  import Plug.Conn

  alias BudgetWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =
      Budget.Accounts.get_user!(conn.assigns[:user_id])
      |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: Routes.plaid_item_path(conn, :new))
        |> halt()

      _ ->
        conn
    end
  end
end
