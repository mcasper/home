defmodule Budget.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :amount_in_cents, :integer, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create_if_not_exists(index(:goals, :user_id))
  end
end
