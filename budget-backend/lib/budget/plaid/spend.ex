defmodule Budget.Plaid.Spend do
  import Ecto.Query

  def calculate(access_token, ignored_transactions) do
    with {:ok, %{"accounts" => balances}} <- get_balances(access_token),
         {:ok, transactions} <-
           get_all_transactions(balances, access_token, ignored_transactions),
         {:ok, total_balance} <- extract_total_balance(balances),
         {:ok, spend_transactions} <- extract_spend(transactions),
         {:ok, total_spend} <- extract_total_spend(spend_transactions),
         {:ok, income_transactions} <- extract_income(transactions),
         {:ok, total_income} <- extract_total_income(income_transactions) do
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

  def categorized_spend(access_token, ignored_transactions) do
    with {:ok, %{"accounts" => balances}} <- get_balances(access_token),
         {:ok, transactions} <-
           get_all_transactions(balances, access_token, ignored_transactions),
         {:ok, categorized_transactions} <- get_all_categorized_transactions(),
         {:ok, categorized_spend} <-
           extract_categorized_spend(transactions, categorized_transactions) do
      {:ok, categorized_spend}
    end
  end

  def uncategorized(access_token, ignored_transactions) do
    with {:ok, %{"accounts" => balances}} <- get_balances(access_token),
         {:ok, transactions} <-
           get_all_transactions(balances, access_token, ignored_transactions),
         {:ok, uncategorized_transactions} <- extract_uncategorized_transactions(transactions) do
      {:ok, uncategorized_transactions}
    end
  end

  def with_category(access_token, category_id, ignored_transactions \\ []) do
    with {:ok, %{"accounts" => balances}} <- get_balances(access_token),
         {:ok, transactions} <-
           get_all_transactions(balances, access_token, ignored_transactions),
         {:ok, filtered_transactions} <-
           extract_transactions_with_category(transactions, category_id) do
      {:ok, filtered_transactions}
    end
  end

  defp get_balances(access_token) do
    Budget.Plaid.Client.get_balances(access_token)
  end

  defp get_all_transactions(balances, access_token, ignored_transactions) do
    ignored_transaction_ids = Enum.map(ignored_transactions, & &1.origin_id)

    txs =
      Enum.flat_map(balances, fn balance ->
        {:ok, %{"transactions" => transactions}} =
          Budget.Plaid.Client.get_transactions(access_token, balance["account_id"])

        transactions
      end)
      |> Enum.filter(fn transaction ->
        !Enum.member?(ignored_transaction_ids, transaction["transaction_id"])
      end)

    {:ok, txs}
  end

  defp extract_uncategorized_transactions(transactions) do
    categorized_transaction_ids =
      Budget.Repo.all(Budget.Plaid.CategorizedTransaction)
      |> Enum.map(& &1.origin_id)

    txs =
      Enum.filter(
        transactions,
        &(!Enum.member?(categorized_transaction_ids, &1["transaction_id"]))
      )

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
        transaction["amount"] > 0 &&
          !(Enum.member?(transaction["category"], "Payment") &&
              Enum.member?(transaction["category"], "Credit Card"))
      end)

    {:ok, txs}
  end

  defp extract_income(transactions) do
    txs =
      Enum.filter(transactions, fn transaction ->
        transaction["amount"] < 0 &&
          !(Enum.member?(transaction["category"], "Transfer") &&
              Enum.member?(transaction["category"], "Credit"))
      end)

    {:ok, txs}
  end

  defp extract_total_spend(transactions) do
    total =
      transactions
      |> Enum.map(& &1["amount"])
      |> Enum.sum()

    {:ok, total}
  end

  defp extract_total_income(transactions) do
    total =
      transactions
      |> Enum.map(&abs(&1["amount"]))
      |> Enum.sum()

    {:ok, total}
  end

  defp get_all_categorized_transactions() do
    categorized_transactions =
      Budget.Plaid.CategorizedTransaction
      |> Budget.Repo.all()
      |> Budget.Repo.preload(:category)

    {:ok, categorized_transactions}
  end

  defp extract_categorized_spend(all_transactions, categorized_transactions) do
    categorized_spend =
      all_transactions
      |> Enum.group_by(fn transaction ->
        categorized_transactions
        |> Enum.filter(&(&1.origin_id == transaction["transaction_id"]))
        |> List.first()
        |> (& &1.category).()
      end)
      |> Enum.map(fn {k, v} ->
        {k, Enum.reduce(v, 0, fn x, acc -> acc + abs(x["amount"]) end)}
      end)

    {:ok, categorized_spend}
  end

  defp extract_transactions_with_category(all_transactions, category_id) do
    categorized_transaction_ids =
      Budget.Plaid.CategorizedTransaction
      |> where([ct], ct.category_id == ^category_id)
      |> Budget.Repo.all()
      |> Enum.map(fn ct -> ct.origin_id end)

    filtered_transactions =
      all_transactions
      |> Enum.filter(fn tx -> Enum.member?(categorized_transaction_ids, tx["transaction_id"]) end)

    {:ok, filtered_transactions}
  end
end
