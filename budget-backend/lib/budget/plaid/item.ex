defmodule Budget.Plaid.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :access_token, :string
    field :origin_id, :string

    belongs_to(:user, Budget.Accounts.User)

    timestamps()
  end

  @required_attributes [:access_token, :user_id, :origin_id]
  @optional_attributes []

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_attributes ++ @optional_attributes)
    |> validate_required(@required_attributes)
  end
end
