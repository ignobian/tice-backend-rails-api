require "open-uri"
require "json"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :send_welcome_email

  enum role: %i(user admin)

  has_many :impressions, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :claps, dependent: :destroy
  has_many :blogs, dependent: :destroy

  has_many :followings
  has_many :followers, through: :followings

  has_one_base64_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :first_name, :last_name, :email, presence: true
  validates :username, length: { minimum: 6 }
  validates :username, uniqueness: true

  def self.create_with_google(info)
    user = User.create(username: info["given_name"].downcase,
                       first_name: info["given_name"],
                       last_name: info["family_name"],
                       email: info["email"],
                       password: info["jti"] + ENV["JWT_SECRET"])

    if !user.valid?
      # generate random username because error is probably that the username is not unique
      user.username = SecureRandom.hex[0..10]
      user.save
    end

    file = URI.open(info["picture"])
    user.photo.attach(io: file, filename: 'googlepic.jpg', content_type: 'image/jpg')
    byebug
    return user
  end

  def self.get_info_from_facebook_access_token(token)
    data = URI.open("https://graph.facebook.com/me?fields=id,name,picture,email&access_token=#{token}").read
    info = JSON.parse(data)
    return info
  end

  def self.create_with_facebook(info)
    user = User.create(username: info["name"].split.first.downcase,
                       first_name: info["name"].split.first,
                       last_name: info["name"].split.last || 'unknown',
                       email: info["email"],
                       password: info["id"] + ENV["JWT_SECRET"])

    if !user.valid?
      # generate random username because error is probably that the username is not unique
      user.username = SecureRandom.hex[0..10]
      user.save
    end

    file = URI.open(info["picture"]["data"]["url"])
    user.photo.attach(io: file, filename: 'facebookpic.jpg', content_type: 'image/jpg')
    return user
  end

  def self.not_deleted
    where(is_deleted: false)
  end

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def generate_jwt
    JWT.encode(
      { user_id: id, exp: (2.weeks.from_now).to_i },
      ENV['JWT_SECRET'],
      'HS256'
    )
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
