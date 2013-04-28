class AddMatchCounterCacheToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :matches_count, :integer, :default => 0

    Category.all.each do |category|
      Category.reset_counters(category.id, :matches)
    end
  end

  def self.down
    remove_column :categories, :matches_count
  end
end
