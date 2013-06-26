class AddSkillLevelToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :skill_level_id, :integer
  end
end
