class BotsCategories < ActiveRecord::Migration
  def up
    create_table :bots_categories, :id => false do |t|
      t.references :bot
      t.references :category
    end
    add_index :bots_categories, [:bot_id, :category_id]
    add_index :bots_categories, [:category_id, :bot_id]
  end

  def down
    drop_table :bots_categories
  end
end
