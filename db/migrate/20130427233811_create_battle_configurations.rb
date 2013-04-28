class CreateBattleConfigurations < ActiveRecord::Migration
  def change
    create_table :battle_configurations do |t|
      t.string :description
      t.integer :num_bots
      t.integer :width
      t.integer :height
      t.integer :num_rounds

      t.timestamps
    end
  end
end
