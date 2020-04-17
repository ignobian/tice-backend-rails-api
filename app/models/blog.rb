class Blog < ApplicationRecord
  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags

  has_many :blog_categories, dependent: :destroy
  has_many :categories, through: :blog_categories

  has_one_base64_attached :photo

  validates :title, :slug, :body, presence: true
  validates :title, length: { minimum: 49, maximum: 61 }
end
