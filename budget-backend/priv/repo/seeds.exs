alias Budget.Repo
alias Budget.Plaid.Category

defmodule Seeds do
  def get_or_insert_category(attrs) do
    case Repo.get_by(Category, attrs) do
      nil -> Repo.insert!(Category.changeset(%Category{}, attrs))
      _ -> nil
    end
  end
end

Seeds.get_or_insert_category(%{name: "Food"})
Seeds.get_or_insert_category(%{name: "Entertainment"})
Seeds.get_or_insert_category(%{name: "Rent"})
