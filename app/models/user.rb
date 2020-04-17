class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :send_welcome_email

  enum role: %i(user admin)

  # has_one_base64_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :first_name, :last_name, :email, :password, presence: true
  validates :username, :password, length: { minimum: 6 }

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
