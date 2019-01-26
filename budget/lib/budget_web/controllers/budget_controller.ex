defmodule BudgetWeb.BudgetController do
  use BudgetWeb, :controller

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
