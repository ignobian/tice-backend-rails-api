json.array! @comments do |comment|
  json.(comment, :content)

  json.user do
    json.(comment.user, :username)
    if comment.user.photo.attached?
      json.photo do
        json.key comment.user.photo.key
      end
    end
  end
end