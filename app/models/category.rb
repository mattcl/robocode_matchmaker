class Category < ActiveRecord::Base
  attr_accessible :name, :battle_size

  has_and_belongs_to_many :bots
end
