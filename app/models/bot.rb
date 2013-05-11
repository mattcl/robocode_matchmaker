class Bot < ActiveRecord::Base
  attr_accessible :user_id, :base_name, :jar_file, :category_ids

  has_attached_file :jar_file

  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :entries
  has_many :matches, :through => :entries

  validates_attachment :jar_file, :presence => true,
    :content_type => { :content_type => 'application/x-java-archive' },
    :size => { :in => 0..2.megabytes }
  validates_presence_of :user_id
  validates :categories, :length => { :minimum => 1, :too_short => 'must specify at least one category' }
  validate :base_name_unique_to_user

  before_validation :assign_base_name

  def averages
    return nil if entries.empty?
    averages = Hash.new { |h, k| h[k] = 0 }
    count = entries.count
    entries.each do |entry|
      averages[:bullet_damage] += entry.bullet_damage
      averages[:bullet_bonus] += entry.bullet_bonus
      averages[:ram_damage] += entry.ram_damage
      averages[:ram_bonus] += entry.ram_bonus
      averages[:survival] += entry.survival
      averages[:survival_bonus] += entry.survival_bonus
    end
    averages
  end

  def proper_name
    self.jar_file_file_name.gsub(/\.jar$/, '')
  end

  private

  def base_name_unique_to_user
    if self.base_name and Bot.where("base_name = ? AND user_id != ?", self.base_name, self.user_id).any?
      errors.add(:jar_file, "the package and name combination has already been taken by another user")
    end
  end

  def assign_base_name
    self.base_name = self.jar_file_file_name.gsub(/_[^_]+.jar/, '') if self.jar_file_file_name
  end
end
