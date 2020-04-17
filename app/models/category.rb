class Category < ApplicationRecord
  validates :name, :slug, presence: true
end
