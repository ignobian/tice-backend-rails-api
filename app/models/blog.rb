class Blog < ApplicationRecord
  include PgSearch::Model

  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags

  has_many :blog_categories, dependent: :destroy
  has_many :categories, through: :blog_categories

  has_many :claps, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :impressions, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user

  has_one_base64_attached :photo

  validates :title, :slug, :body, presence: true
  validates :title, :slug, uniqueness: true
  validates :title, length: { minimum: 49, maximum: 61 }
  validate :body_min_word_length, :body_minimum_two_images

  # search scope
  pg_search_scope :search,
                  against: [:title, :body],
                  associated_against: {
                    categories: :name,
                    tags: :name
                  }

  pg_search_scope :search_by_title, against: [:title]
  pg_search_scope :search_by_body, against: [:body]
  pg_search_scope :search_by_username, associated_against: {
                                                             user: :username
                                                           }
  def self.last_modified
    order('updated_at DESC').first.updated_at
  end

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
      blogs = Blog.joins(:categories).where('categories.name = ?', category.name)
      arr << blogs.to_a
    end
    return arr[0..2].flatten if arr.count > 3

    return arr.flatten
  end

  private

  def body_strip_html
    ActionView::Base.full_sanitizer.sanitize(body)
  end
end
