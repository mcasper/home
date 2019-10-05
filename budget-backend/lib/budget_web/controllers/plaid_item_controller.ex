defmodule BudgetWeb.PlaidItemController do
  use BudgetWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html", csrf_token: get_csrf_token())
  end

  def create(conn, %{"public_token" => public_token}) do
    case Budget.Plaid.Client.exchange_token(public_token) do
      {:ok, %{"access_token" => access_token, "item_id" => item_id}} ->
        current_user = current_user(conn)
        Budget.Plaid.delete_existing_items_for_user(current_user)

        {:ok, _} =
          Budget.Plaid.create_item(%{
            "access_token" => access_token,
            "user_id" => current_user.id,
            "origin_id" => item_id
          })

        conn
        |> put_flash(:info, "Hooked up your bank account")
        |> redirect(to: Routes.account_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error hooking up your bank account")
        |> redirect(to: Routes.plaid_item_path(conn, :new))
    end
  end

  defp current_user(conn) do
    Budget.Accounts.get_user!(conn.assigns[:user_id])
  end
end
