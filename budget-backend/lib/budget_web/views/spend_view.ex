defmodule BudgetWeb.SpendView do
  use BudgetWeb, :view

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
