class Match < ActiveRecord::Base
  attr_accessible :category_id, :finished_at, :started_at

  has_one :category
  has_many :entries
  has_many :bots, :through => :entries

  def self.generate(category_id)
    category = Category.find(category_id)
    bots = bots.group(:base_name).pluck(:jar_file_file_name)
  end
end
