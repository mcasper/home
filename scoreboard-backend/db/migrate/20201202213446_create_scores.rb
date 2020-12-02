class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.string :name, null: false
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end
end
