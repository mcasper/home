defmodule Budget.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :access_token, :text, null: false
      add :origin_id, :text, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create_if_not_exists(index(:items, :user_id))
    create_if_not_exists(index(:items, :origin_id))
  end
end
