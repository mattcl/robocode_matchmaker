class BattleConfiguration < ActiveRecord::Base
  attr_accessible :description, :height, :num_bots, :num_rounds, :width

  has_many :categories

  validates_presence_of :description
  validates :num_bots, :presence => true, :numericality => { :only_integer => true }
  validates :num_rounds, :presence => true, :numericality => { :only_integer => true }
  validates :width, :presence => true, :numericality => { :only_integer => true }
  validates :height, :presence => true, :numericality => { :only_integer => true }
end
