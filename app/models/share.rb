class Share < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :blog

  enum share_type: %i(twitter linkedin facebook)

  validates :share_type, presence: true
  validates :user, uniqueness: { scope: [:blog, :share_type], message: 'You already shared this post with this type' }
end
