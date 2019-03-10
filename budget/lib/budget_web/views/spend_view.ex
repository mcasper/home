defmodule BudgetWeb.SpendView do
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
end
