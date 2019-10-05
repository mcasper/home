defmodule Budget.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create(table(:categories)) do
      add(:name, :text, null: false)

      timestamps()
    end

    create_if_not_exists(unique_index(:categories, :name))
  end
end
