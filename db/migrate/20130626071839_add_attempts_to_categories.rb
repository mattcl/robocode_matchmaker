class AddAttemptsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :attempts, :integer, :default => 0
  end
end
