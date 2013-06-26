class Category < ActiveRecord::Base
  attr_accessible :name, :battle_configuration, :skill_level, :attempts

  has_and_belongs_to_many :bots
  has_many :matches
  belongs_to :battle_configuration
  belongs_to :skill_level

  validates_presence_of :name
  validates_presence_of :battle_configuration

  scope :by_fewest_attempts, -> { order('attempts ASC') }
  scope :by_fewest_matches, -> { order('matches_count ASC') }

  def self.best_for_next_match
    Category.by_fewest_attempts.first
  end

  def detail_name
    "#{skill_level.name} #{name}"
  end

  def note_attempt
    increment!(:attempts)
  end

  def unique_bots
    # we know that base_name is unique per-user, so this is okay
    bots.group(:base_name)
  end
end
