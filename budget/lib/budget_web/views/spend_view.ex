defmodule BudgetWeb.SpendView do
  use BudgetWeb, :view

  # def format_net(income, spend) do
  #   abs_income = abs(income)
  #   abs_spend = abs(spend)

  #   if abs_income > abs_spend do
  #     "+#{format_float(abs_income - abs_spend)}"
  #   else
  #     "-#{format_float(abs_spend - abs_income)}"
  #   end
  # end

  def format_float(float) do
    cents = trunc(float * 100)
    format_cents(cents)
  end

  def format_cents(cents) do
    cents
    |> Money.new()
    |> Money.to_string()
  end
end
