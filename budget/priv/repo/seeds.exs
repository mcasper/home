alias Budget.Repo
alias Budget.Plaid.Category

Repo.insert!(Category.changeset(%Category{}, %{"name" => "Food"}))
Repo.insert!(Category.changeset(%Category{}, %{"name" => "Entertainment"}))
Repo.insert!(Category.changeset(%Category{}, %{"name" => "Rent"}))
