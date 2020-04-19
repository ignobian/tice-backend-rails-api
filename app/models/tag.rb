class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :blog_tags
  has_many :blogs, through: :blog_tags
end
