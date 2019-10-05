defmodule BudgetWeb.CategorizeSpendController do
  use BudgetWeb, :controller

  def index(conn, _params) do
    current_user =
      current_user(conn)
      |> Budget.Repo.preload([:item, :ignored_transactions])

    categories = Budget.Repo.all(Budget.Plaid.Category)
    category_options = [{"Select a category", 0}] ++ Enum.map(categories, &{&1.name, &1.id})

    case current_user.item do
      nil ->
        redirect(conn, to: Routes.plaid_item_path(conn, :new))

      item ->
        case Budget.Plaid.Spend.uncategorized(
               item.access_token,
               current_user.ignored_transactions
             ) do
          {:ok, uncategorized_transactions} ->
            render(
              conn,
              :index,
              uncategorized_transactions: uncategorized_transactions,
              categories: category_options
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
