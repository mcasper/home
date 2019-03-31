defmodule BudgetWeb.PlaidCategorizedTransactionController do
  use BudgetWeb, :controller

  def create(conn, %{"categorized_transaction" => categorized_transaction_params}) do
    current_user = current_user(conn)
    create_params = Map.merge(categorized_transaction_params, %{"user_id" => current_user.id})
    case Budget.Plaid.create_categorized_transaction(create_params) do
      {:ok, _categorized_transaction} ->
        redirect(conn, to: Routes.categorize_spend_path(conn, :index))

      {:error, _changeset} ->
        redirect(conn, to: Routes.categorize_spend_path(conn, :index))
    end
  end

  defp current_user(conn) do
    Budget.Accounts.get_user!(conn.assigns[:user_id])
  end
end
