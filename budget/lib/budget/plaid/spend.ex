defmodule Budget.Plaid.Spend do
  def calculate(access_token) do
    with {:ok, %{"accounts" => balances}} = get_balances(access_token),
         {:ok, transactions} = get_all_transactions(balances, access_token),
         {:ok, total_balance} = extract_total_balance(balances),
         {:ok, spend_transactions} = extract_spend(transactions),
         {:ok, total_spend} = extract_total_spend(spend_transactions),
         {:ok, income_transactions} = extract_income(transactions),
         {:ok, total_income} = extract_total_income(income_transactions) do
      {:ok,
       %{
         total_balance: total_balance,
         total_spend: total_spend,
         total_income: total_income,
         spend_transactions: spend_transactions,
         income_transactions: income_transactions
       }}
    end
  end

  defp get_balances(access_token) do
    Budget.Plaid.Client.get_balances(access_token)
  end

  defp get_all_transactions(balances, access_token) do
    txs =
      Enum.flat_map(balances, fn balance ->
        {:ok, %{"transactions" => transactions}} =
          Budget.Plaid.Client.get_transactions(access_token, balance["account_id"])

        transactions
      end)

    {:ok, txs}
  end

  defp extract_total_balance(balances) do
    total =
      balances
      |> Enum.map(& &1["balances"]["current"])
      |> Enum.sum()

    {:ok, total}
  end

  defp extract_spend(transactions) do
    txs =
      Enum.filter(transactions, fn transaction ->
        transaction["amount"] > 0
      end)

    {:ok, txs}
  end

  defp extract_income(transactions) do
    txs =
      Enum.filter(transactions, fn transaction ->
        transaction["amount"] < 0
      end)

    {:ok, txs}
  end

  def extract_total_spend(transactions) do
    total =
      transactions
      |> Enum.map(& &1["amount"])
      |> Enum.sum()

    {:ok, total}
  end

  def extract_total_income(transactions) do
    total =
      transactions
      |> Enum.map(&abs(&1["amount"]))
      |> Enum.sum()

    {:ok, total}
  end
end
