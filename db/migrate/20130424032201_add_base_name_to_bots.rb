class AddBaseNameToBots < ActiveRecord::Migration
  def change
    add_column :bots, :base_name, :string, :null => false, :default => ''
  end
end
