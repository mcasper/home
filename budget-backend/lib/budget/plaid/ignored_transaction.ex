defmodule Budget.Plaid.IgnoredTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ignored_transactions" do
    field :origin_id, :string

    belongs_to(:user, Budget.Accounts.User)

    timestamps()
  end

  @required_attributes [:user_id, :origin_id]
  @optional_attributes []

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_attributes ++ @optional_attributes)
    |> validate_required(@required_attributes)
  end
end
