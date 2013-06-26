class SkillLevel < ActiveRecord::Base
  attr_accessible :name

  has_many :categories

  validates_presence_of :name
  validates_uniqueness_of :name
end
