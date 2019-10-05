defmodule Budget.Budget.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field(:amount_in_cents, :integer)
    belongs_to(:user, Budget.Accounts.User)

    timestamps()
  end

  @required_attributes [:amount_in_cents, :user_id]
  @optional_attributes []

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, @required_attributes ++ @optional_attributes)
    |> validate_required(@required_attributes)
  end
end
