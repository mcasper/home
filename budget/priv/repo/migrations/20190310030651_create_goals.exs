defmodule Budget.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :amount_in_cents, :integer, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create(index(:goals, :user_id))
  end
end
