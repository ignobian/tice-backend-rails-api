class Blog < ApplicationRecord
  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags

  has_many :blog_categories, dependent: :destroy
  has_many :categories, through: :blog_categories

  has_many :claps, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :impressions, dependent: :destroy
  has_many :reports, dependent: :destroy

  belongs_to :user

  has_one_base64_attached :photo

  validates :title, :slug, :body, presence: true
  validates :title, :slug, uniqueness: true
  validates :title, length: { minimum: 49, maximum: 61 }
  validate :body_min_word_length, :body_minimum_two_images

  # custom validations
  def body_min_word_length
    if body_strip_html.split(' ').length < 300
      errors.add(:body, 'has to have at least 300 words')
    end
  end

  def body_minimum_two_images
    if body.scan(/<img src="[^"]*">/).count < 2
      errors.add(:body, 'needs to have 2 images')
    end
  end

  # methods to fetch certain data from it
  def keywords
    TextRank.extract_keywords(body_strip_html).keys
  end

  def mdesc
    "#{title} #{body_strip_html[0..(158 - title.length)]}"
  end

  def excerpt
    length = 320
    body_strip_html[0..(320 - 3)] + '...'
  end

  def related
    arr = []
    categories.each do |category|
      blogs = Blog.includes(:categories).where('categories.name = ?', category.name)
      arr << blogs
    end
    return arr[0..2] if arr.count > 3

    return arr
  end

  private

  def body_strip_html
    ActionView::Base.full_sanitizer.sanitize(body)
  end
end
