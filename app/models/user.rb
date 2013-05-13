class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :bots

  def matches_entered
    @matches_entered ||= bots.collect { |bot| bot.entries.count }.reduce(:+)
    return 0 if @matches_entered.nil?
    @matches_entered
  end

  def matches_won
    @matches_won ||= bots.collect { |bot| bot.entries.where(:rank => 1).count }.reduce(:+)
    return 0 if @matches_won.nil?
    @matches_won
  end
end
