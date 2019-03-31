defmodule Budget.Plaid.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    timestamps()
  end

  @required_attributes [:name]
  @optional_attributes []

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_attributes ++ @optional_attributes)
    |> validate_required(@required_attributes)
  end
end
