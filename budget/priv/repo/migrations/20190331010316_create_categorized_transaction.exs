defmodule Budget.Repo.Migrations.CreateCategorizedTransaction do
  use Ecto.Migration

  def change do
    create(table(:categorized_transactions)) do
      add(:origin_id, :text, null: false)
      add(:user_id, references(:users), null: false)
      add(:category_id, references(:categories), null: false)

      timestamps()
    end

    create_if_not_exists(unique_index(:categorized_transactions, :origin_id))
  end
end
