class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :token
      t.string :name
      t.timestamps
    end

    add_index :games, :token, unique: true
    add_index :games, :name
  end
end
