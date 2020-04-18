class Share < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  enum type: %i(twitter linkedin facebook)

  validates :type, presence: true
end
