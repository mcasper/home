defmodule BudgetWeb.HealthController do
  use BudgetWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(:ok, "")
  end
end
