defmodule BudgetWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  object :transaction do
    field :amount, :float
    field :name, :string
    field :date, :string
    field :transaction_id, :string
  end

  object :category do
    field :name, :string
    field :id, :id
  end

  object :categorized_transaction do
    field :origin_id, :string
    field :user_id, :id
    field :category_id, :id
  end

  object :categorized_spend do
    field :amount, :float
    field :category, :category
  end
end

defmodule BudgetWeb.Graphql.Resolvers do
  def get_transactions(_parent, _args, %{context: %{user_id: user_id}}) do
    current_user =
      current_user(user_id)
      |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        {:error, "Plaid auth required"}

      item ->
        case Budget.Plaid.Spend.uncategorized(item.access_token, []) do
          {:ok, txs} ->
            {:ok,
             Enum.map(txs, fn tx -> Map.new(tx, fn {k, v} -> {String.to_atom(k), v} end) end)}

          {:error, err} ->
            {:error, err}
        end
    end
  end

  def get_transactions(_parent, _args, _context), do: {:error, "Unauthorized"}

  def get_categories(_parent, _args, %{context: %{user_id: _}}) do
    categories =
      Budget.Plaid.Category
      |> Budget.Repo.all()

    {:ok, categories}
  end

  def get_categories(_parent, _args, _context), do: {:error, "Unauthorized"}

  def exchange_plaid_token(_parent, %{token: token}, %{context: %{user_id: user_id}}) do
    case Budget.Plaid.Client.exchange_token(token) do
      {:ok, %{"access_token" => access_token, "item_id" => item_id}} ->
        current_user = current_user(user_id)
        Budget.Plaid.delete_existing_items_for_user(current_user)

        {:ok, _} =
          Budget.Plaid.create_item(%{
            "access_token" => access_token,
            "user_id" => current_user.id,
            "origin_id" => item_id
          })

        {:ok, "Success"}

      {:error, err} ->
        {:error, err}
    end
  end

  def exchange_plaid_token(_parent, _args, _context), do: {:error, "Unauthorized"}

  def create_category(_parent, %{name: name}, %{context: %{user_id: _}}) do
    case Budget.Plaid.create_category(%{name: name}) do
      {:ok, category} ->
        {:ok, category}

      {:error, _changeset} ->
        {:error, "Error creating category"}
    end
  end

  def create_category(_parent, _args, _context), do: {:error, "Unauthorized"}

  def create_categorized_transaction(_parent, args, %{context: %{user_id: user_id}}) do
    create_params = Map.merge(args, %{user_id: user_id})

    case Budget.Plaid.create_categorized_transaction(create_params) do
      {:ok, categorized_transaction} ->
        {:ok, categorized_transaction}

      {:error, _changeset} ->
        {:error, "Error creating categorized transaction"}
    end
  end

  def create_categorized_transaction(_parent, _args, _context), do: {:error, "Unauthorized"}

  def get_categorized_spend(_parent, %{from: _from}, %{context: %{user_id: user_id}}) do
    current_user =
      current_user(user_id)
      |> Budget.Repo.preload(:item)

    case current_user.item do
      nil ->
        {:error, "Plaid auth required"}

      item ->
        case Budget.Plaid.Spend.categorized_spend(item.access_token, []) do
          {:ok, categorized_spend} ->
            mapped_spend =
              Enum.map(categorized_spend, fn {k, v} ->
                %{
                  amount: v,
                  category: k
                }
              end)

            {:ok, mapped_spend}

          {:error, err} ->
            {:error, err}
        end
    end
  end

  def get_categorized_spend(_parent, _args, _context), do: {:error, "Unauthorized"}

  defp current_user(user_id) do
    Budget.Accounts.get_user!(user_id)
  end
end

defmodule BudgetWeb.Graphql.Schema do
  use Absinthe.Schema
  import_types(BudgetWeb.Graphql.Types)

  def parse_datetime(string) do
    {:ok, datetime, _offset} = DateTime.from_iso8601(string)
    {:ok, datetime}
  end

  scalar :datetime do
    description("DateTime (in iso8601 format)")
    parse(&BudgetWeb.Graphql.Schema.parse_datetime(&1.value))
    serialize(&DateTime.to_iso8601(&1.value))
  end

  query do
    field :transactions, list_of(:transaction) do
      resolve(&BudgetWeb.Graphql.Resolvers.get_transactions/3)
    end

    field :categories, list_of(:category) do
      resolve(&BudgetWeb.Graphql.Resolvers.get_categories/3)
    end

    field :categorized_spend, list_of(:categorized_spend) do
      arg(:from, non_null(:datetime))
      resolve(&BudgetWeb.Graphql.Resolvers.get_categorized_spend/3)
    end
  end

  mutation do
    field :exchange_plaid_token, type: :string do
      arg(:token, non_null(:string))

      resolve(&BudgetWeb.Graphql.Resolvers.exchange_plaid_token/3)
    end

    field :create_category, type: :category do
      arg(:name, non_null(:string))

      resolve(&BudgetWeb.Graphql.Resolvers.create_category/3)
    end

    field :create_categorized_transaction, type: :categorized_transaction do
      arg(:origin_id, non_null(:string))
      arg(:category_id, non_null(:id))

      resolve(&BudgetWeb.Graphql.Resolvers.create_categorized_transaction/3)
    end
  end
end
