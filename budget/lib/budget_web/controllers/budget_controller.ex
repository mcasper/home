defmodule BudgetWeb.BudgetController do
  use BudgetWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end
end
