class Match < ActiveRecord::Base
  attr_accessible :category, :finished_at, :started_at, :bots, :entries_attributes

  belongs_to :category, :counter_cache => true
  has_many :entries
  has_many :bots, :through => :entries

  accepts_nested_attributes_for :entries

  validates_presence_of :category

  scope :pending, -> { where(:started_at => nil) }
  scope :running, -> { where('started_at IS NOT NULL AND finished_at IS NULL') }
  scope :finished, -> { where('finished_at IS NOT NULL') }

  def self.create_for(category)
    configuration = category.battle_configuration
    bots = category.unique_bots.to_a

    return nil if bots.empty? or bots.count < 2

    if bots.count > configuration.num_bots
      # shuffle the array (this will help make it fairer for bots
      # that have the same number of entries
      bots = bots.shuffle

      # sort based on the number of entries for the given category
      bots = bots.sort { |a, b| a.matches.where(:category_id => category).count <=> b.matches.where(:category_id => category).count }

      # take as many as we can
      bots = bots.slice(0, configuration.num_bots)
    end

    match = Match.create(:category => category, :bots => bots)
  end

  def status
    return 'pending' if started_at.nil?
    return 'running' if finished_at.nil?
    'finished'
  end

  def winner
    return nil if finished_at.nil?
    @winner ||= entries.where(:rank => 1).first
  end
end
