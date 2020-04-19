class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :send_welcome_email

  enum role: %i(user admin)

  has_many :impressions
  has_many :shares
  has_many :claps
  has_many :blogs

  has_many :followings
  has_many :followers, through: :followings
  # has_many :following_associations, class_name: 'Following', foreign_key: 'user_id'
  # has_many :followings, through: :following_associations, source: :user

  has_one_base64_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :first_name, :last_name, :email, presence: true
  validates :username, length: { minimum: 6 }

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def follower_ids
    followers.map { |follower| follower.id }
  end

  def feed_blogs
    Blog.where(user: followers).order('created_at DESC')
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
