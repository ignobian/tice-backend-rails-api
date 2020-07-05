class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :content, presence: true

  def json_hash
    { message: {
      id: id,
      content: content,
      createdAt: created_at,
      from: {
        id: user.id,
        photo: user.photo.attached? ? user.photo.key : nil,
        username: user.username
      } } }.to_json
  end
end
