defmodule BudgetWeb.GoalView do
  use BudgetWeb, :view

  def net(income, spend) do
    abs_income = abs(income)
    abs_spend = abs(spend)

    if abs_income > abs_spend do
      "+#{abs_income - abs_spend}"
    else
      "-#{abs_spend - abs_income}"
    end
  end

  def estimate_goal_completion(goal_in_cents, current_balance, income_last_30, spend_last_30) do
    if abs(income_last_30) < abs(spend_last_30) do
      "Never"
    else
      daily_net = (abs(income_last_30) - abs(spend_last_30)) / 30
      difference = current_balance - (goal_in_cents / 100)
      days = difference / daily_net
      "#{days} Days"
    end
  end
end
