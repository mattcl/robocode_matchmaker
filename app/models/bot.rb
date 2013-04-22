class Bot < ActiveRecord::Base
  attr_accessible :user_id, :jar_file

  has_attached_file :jar_file
  validates_attachment :jar_file, :presence => true,
    :content_type => { :content_type => 'application/java-archive' },
    :size => { :in => 0..2.megabytes }

  belongs_to :user
end
