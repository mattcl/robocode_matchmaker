class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :bot_id
      t.integer :match_id
      t.integer :rank
      t.integer :total_score
      t.integer :survival
      t.integer :survival_bonus
      t.integer :bullet_damage
      t.integer :bullet_bonus
      t.integer :ram_damage
      t.integer :ram_bonus
      t.integer :firsts
      t.integer :seconds
      t.integer :thirds

      t.timestamps
    end
  end
end
