class MakeCategoryIdNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:recipes, :category_id, false)
  end
end
