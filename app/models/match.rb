class Match < ActiveRecord::Base
  attr_accessible :category_id, :finished_at, :started_at

  has_one :category
  has_many :entries
  has_many :bots, :through => :entries
end
