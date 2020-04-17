class Blog < ApplicationRecord

  validates :title, :slug, :body, presence: true
  validates :title, length: { minimum: 49, maximum: 61 }
end
