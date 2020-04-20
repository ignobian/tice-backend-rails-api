class Category < ApplicationRecord
  has_many :blog_categories
  has_many :blogs, through: :blog_categories

  validates :name, :slug, presence: true
end
