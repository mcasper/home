defmodule BudgetWeb.SpendController do
  use BudgetWeb, :controller

  plug BudgetWeb.HasItemPlug
  plug BudgetWeb.HasGoalPlug

  def index(conn, _params) do
    current_user =
      current_user(conn)
      |> Budget.Repo.preload([:item, :ignored_transactions])

    case current_user.item do
      nil ->
        redirect(conn, to: Routes.plaid_item_path(conn, :new))

      item ->
        case Budget.Plaid.Spend.calculate(item.access_token, current_user.ignored_transactions) do
          {:ok,
           %{
             total_balance: total_balance,
             total_spend: total_spend,
             total_income: total_income,
             spend_transactions: spend_transactions,
             income_transactions: income_transactions
           }} ->
            render(
              conn,
              :index,
              total_balance: total_balance,
              total_spend: total_spend,
              total_income: total_income,
              spend_transactions: spend_transactions,
              income_transactions: income_transactions
            )

          {:error, _} ->
            redirect(conn, to: Routes.plaid_item_path(conn, :new))
        end
    end
  end

  defp current_user(conn) do
    Budget.Accounts.get_user!(conn.assigns[:user_id])
  end
end
