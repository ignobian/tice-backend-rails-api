class Category < ApplicationRecord
  has_many :blog_categories
  has_many :blogs, through: :blog_categories

  validates :name, :slug, presence: true

  def last_modified
    if blogs.empty?
      updated_at
    else
      blogs.order('updated_at DESC').first.updated_at
    end
  end
end
