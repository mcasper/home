class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :player_one, null: false
      t.string :player_two, null: false
      t.string :game, null: false

      t.timestamps
    end
  end
end
