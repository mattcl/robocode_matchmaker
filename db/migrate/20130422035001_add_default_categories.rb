class AddDefaultCategories < ActiveRecord::Migration
  def up
    Category.where(:name => 'Mele').first_or_create!(:battle_size => 5)
    Category.where(:name => '1v1').first_or_create!(:battle_size => 2)
  end
end
