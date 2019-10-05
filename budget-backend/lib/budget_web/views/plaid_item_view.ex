defmodule BudgetWeb.PlaidItemView do
  use BudgetWeb, :view

  def plaid_env do
    if Mix.env() == :prod do
      'development'
    else
      'sandbox'
    end
  end
end
