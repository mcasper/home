defmodule Budget.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create(table(:users)) do
      add(:email, :text, null: false)

      timestamps()
    end

    create_if_not_exists(unique_index(:users, :email))
  end
end
