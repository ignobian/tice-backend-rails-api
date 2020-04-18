class Share < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  enum type: %i(twitter linkedin facebook)

  validates :type, presence: true
  validates :user, uniqueness: { scope: [:blog, :type], message: 'You already shared this post with this type' }
end
