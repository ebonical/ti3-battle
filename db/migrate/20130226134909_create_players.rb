class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :number
      t.string :color
      t.string :race
      t.text :technologies
      t.integer :game_id
      t.timestamps
    end

    add_index :players, :number
    add_index :players, :game_id
  end
end
