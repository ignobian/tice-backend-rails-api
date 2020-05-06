class Category < ApplicationRecord
  has_many :blog_categories
  has_many :blogs, through: :blog_categories

  validates :name, :slug, presence: true

  def last_modified
    blogs.order('updated_at DESC').last.updated_at
  end
end
