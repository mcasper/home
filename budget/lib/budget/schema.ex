defmodule BudgetWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  object :transaction do
    field :amount, :float
    field :name, :string
    field :date, :string
    field :transaction_id, :string
  end
end

defmodule BudgetWeb.Graphql.Resolvers do
  def get_transactions(_parent, _args, _resolution) do
    user = Budget.Accounts.User
           |> Budget.Repo.one()
           |> Budget.Repo.preload(:item)
    {:ok, txs} = Budget.Plaid.Spend.uncategorized(user.item.access_token, [])
    {:ok, Enum.map(txs, fn tx -> Map.new(tx, fn {k, v} -> {String.to_atom(k), v} end) end)}
  end
end

defmodule BudgetWeb.Graphql.Schema do
  use Absinthe.Schema
  import_types BudgetWeb.Graphql.Types

  query do
    field :transactions, list_of(:transaction) do
      resolve &BudgetWeb.Graphql.Resolvers.get_transactions/3
    end
  end
end
