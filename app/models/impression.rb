class Impression < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :blog
end
