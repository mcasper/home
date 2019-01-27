defmodule BudgetWeb.BudgetController do
  use BudgetWeb, :controller

  def show(conn, _params) do
    render(conn, "show.html", csrf_token: get_csrf_token())
  end
end
