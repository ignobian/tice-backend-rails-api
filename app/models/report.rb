class Report < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  REPORT_TYPES = [
    'Sexual content',
    'Violent content',
    'Hateful content',
    'Spam',
    'Copyright content'
  ]

end
