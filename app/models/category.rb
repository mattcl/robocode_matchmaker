class Category < ActiveRecord::Base
  attr_accessible :name, :battle_configuration

  has_and_belongs_to_many :bots
  has_many :matches
  belongs_to :battle_configuration

  validates_presence_of :name
  validates_presence_of :battle_configuration

  def unique_bots
    # we know that base_name is unique per-user, so this is okay
    bots.group(:base_name)
  end
end
