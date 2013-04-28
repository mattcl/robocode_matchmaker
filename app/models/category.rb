class Category < ActiveRecord::Base
  attr_accessible :name, :battle_configuration

  has_and_belongs_to_many :bots
  has_many :matches
  belongs_to :battle_configuration

  validates_presence_of :name
  validates_presence_of :battle_configuration
end
