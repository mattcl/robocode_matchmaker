class AddActiveToBot < ActiveRecord::Migration
  def change
    add_column :bots, :active, :boolean, :default => true
  end
end
