class CreateScoreChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :score_changes do |t|
      t.text :player, null: false
      t.integer :change, null: false
      t.belongs_to :match, null: false

      t.timestamps
    end
  end
end
