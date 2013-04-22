class Bot < ActiveRecord::Base
  attr_accessible :user_id, :jar_file, :categories

  has_attached_file :jar_file
  validates_attachment :jar_file, :presence => true,
    :content_type => { :content_type => 'application/java-archive' },
    :size => { :in => 0..2.megabytes }

  validates_presence_of :user_id

  belongs_to :user
  has_and_belongs_to_many :categories
end
