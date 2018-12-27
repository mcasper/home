class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.text :name, null: false
      t.text :url, null: false
    end
  end
end
