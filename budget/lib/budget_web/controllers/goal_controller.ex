defmodule BudgetWeb.GoalController do
  use BudgetWeb, :controller

  alias Budget.Accounts
  alias Budget.Budget.Goal

  plug BudgetWeb.HasItemPlug
  plug BudgetWeb.HasGoalPlug when action in [:show]

  def new(conn, _params) do
    changeset = Budget.Budget.change_goal(%Goal{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"goal" => goal_params}) do
    current_user = current_user(conn)
    create_params = Map.merge(goal_params, %{"user_id" => current_user.id})

    case Budget.Budget.create_goal(create_params) do
      {:ok, _goal} ->
        redirect(conn, to: Routes.goal_path(conn, :show))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error saving your goal")
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, _params) do
    current_user = current_user(conn) |> Budget.Repo.preload([:item, :goal, :ignored_transactions])
    goal = current_user.goal

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
              :show,
              goal: goal,
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

  def edit(conn, _params) do
    current_user = current_user(conn) |> Budget.Repo.preload(:goal)
    goal = current_user.goal
    changeset = Budget.Budget.change_goal(goal)
    render(conn, :edit, changeset: changeset)
  end

  def update(conn, %{"goal" => goal_params}) do
    current_user = current_user(conn) |> Budget.Repo.preload(:goal)
    goal = current_user.goal

    case Budget.Budget.update_goal(goal, goal_params) do
      {:ok, _goal} ->
        redirect(conn, to: Routes.goal_path(conn, :show))

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  defp current_user(conn) do
    Accounts.get_user!(conn.assigns[:user_id])
  end
end
