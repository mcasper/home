defmodule Budget.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string

    timestamps()
  end

  @required_attributes [:email]
  @optional_attributes []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_attributes ++ @optional_attributes)
    |> validate_required(@required_attributes)
  end
end
