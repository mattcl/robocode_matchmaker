class Bot < ActiveRecord::Base
  attr_accessible :user_id, :base_name, :jar_file, :category_ids

  has_attached_file :jar_file

  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :entries
  has_many :matches, :through => :entries

  # validations
  validates_attachment :jar_file, :presence => true,
    :content_type => { :content_type => 'application/x-java-archive' },
    :size => { :in => 0..2.megabytes }

  validates_presence_of :user_id
  validates :categories, :length => { :minimum => 1, :too_short => 'must specify at least one category' }
  before_save :assign_base_name

  private

  def assign_base_name
    self.base_name = self.jar_file_file_name.gsub(/_[^_]+.jar/, '')
  end
end
