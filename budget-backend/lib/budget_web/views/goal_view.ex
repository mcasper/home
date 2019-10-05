defmodule BudgetWeb.GoalView do
  use BudgetWeb, :view

  def format_net(income, spend) do
    abs_income = abs(income)
    abs_spend = abs(spend)

    if abs_income > abs_spend do
      "+#{format_float(abs_income - abs_spend)}"
    else
      "-#{format_float(abs_spend - abs_income)}"
    end
  end

  def estimate_goal_completion(goal_in_cents, current_balance, income_last_30, spend_last_30) do
    if abs(income_last_30) < abs(spend_last_30) do
      "Never"
    else
      daily_net = (abs(income_last_30) - abs(spend_last_30)) / 30
      goal_in_dollars = goal_in_cents / 100
      difference = goal_in_dollars - current_balance
      days = trunc(Float.ceil(difference / daily_net))
      "#{days} Days"
    end
  end

  def format_cents(cents) do
    cents
    |> Money.new()
    |> Money.to_string()
  end

  def format_float(float) do
    cents = trunc(float * 100)
    format_cents(cents)
  end

  def money_input(form, field, opts) do
    text_input(form, field, opts ++ [onkeyup: "App.formatPrice(this)"])
  end
end
