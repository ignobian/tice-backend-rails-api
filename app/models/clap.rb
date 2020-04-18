class Clap < ApplicationRecord
  belongs_to :blog
  belongs_to :user

  validates :user_id, uniqueness: { scope: :blog_id, message: 'You already clapped this post' }
end
