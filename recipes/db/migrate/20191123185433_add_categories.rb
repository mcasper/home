class AddCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.text :name, null: false

      t.timestamps
    end

    add_column(:recipes, :category_id, :bigint, index: true)
  end
end
