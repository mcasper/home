defmodule BudgetWeb.HasGoalPlug do
  import Plug.Conn

  alias BudgetWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =
      Budget.Accounts.get_user!(conn.assigns[:user_id])
      |> Budget.Repo.preload(:goal)

    case current_user.goal do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: Routes.goal_path(conn, :new))
        |> halt()

      _ ->
        conn
    end
  end
end
