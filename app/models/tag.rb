class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :blog_tags
  has_many :blogs, through: :blog_tags

  def featured
    Tag.joins(:blog_tags).group('blog_tags.tag_id').order('count(blog_tags.tag_id) desc').limit(10)
  end
end
