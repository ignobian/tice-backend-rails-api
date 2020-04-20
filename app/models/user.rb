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

  def is_following
    User.joins(:followings).where(followings: { follower: self } )
  end

  def feed_blogs
    Blog.where(user: is_following).order('created_at DESC').limit(10)
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
