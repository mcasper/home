class AddNotesToRecipe < ActiveRecord::Migration[6.0]
  def up
    add_column(:recipes, :notes, :text)
    change_column_null(:recipes, :url, true)
  end

  def down
    remove_column(:recipes, :notes, :text)
    change_column_null(:recipes, :url, false)
  end
end
