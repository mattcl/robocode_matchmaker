class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :battle_size, :null => false, :default => 0
    end
  end
end
