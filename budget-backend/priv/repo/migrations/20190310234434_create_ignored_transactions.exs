defmodule Budget.Repo.Migrations.CreateIgnoredTransactions do
  use Ecto.Migration

  def change do
    create(table(:ignored_transactions)) do
      add(:origin_id, :text, null: false)
      add(:user_id, references(:users), null: false)

      timestamps()
    end

    create_if_not_exists(unique_index(:ignored_transactions, :origin_id))
  end
end
