class Match < ActiveRecord::Base
  attr_accessible :category_id, :finished_at, :started_at

  belongs_to :category
  has_many :entries
  has_many :bots, :through => :entries

  validates_presence_of :category

  def self.create_for(category)

  end
end
