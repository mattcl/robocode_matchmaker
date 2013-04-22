class AddDefaultCategories < ActiveRecord::Migration
  def up
    Category.where(:name => 'Mele').first_or_create!
    Category.where(:name => '1v1').first_or_create!
  end
end
