class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :blog_tags
  has_many :blogs, through: :blog_tags

  def self.featured
    @tags = Tag.all.sort { |t, nt| nt.blog_count <=> t.blog_count }.first(10)
  end

  def blog_count
    blogs.count
  end
end
