class Entry < ActiveRecord::Base
  attr_accessible :bot_id, :bullet_bonus, :bullet_damage, :firsts, :match_id,
    :ram_bonus, :ram_damage, :rank, :seconds, :survival, :survival_bonus, :thirds, :total_score

  belongs_to :bot, :counter_cache => true
  belongs_to :match

  validates :bullet_bonus, :bullet_damage, :firsts, :ram_bonus, :ram_damage,
    :rank, :seconds, :survival, :survival_bonus, :thirds, :total_score,
    :numericality => {:only_integer => true}, :on => :update

  scope :finished, -> { where('rank IS NOT NULL') }
end
