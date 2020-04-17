class Blog < ApplicationRecord

  has_one_base64_attached :photo

  validates :title, :slug, :body, presence: true
  validates :title, length: { minimum: 49, maximum: 61 }
end
