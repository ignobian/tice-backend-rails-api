json.key_format! camelize: :lower

json.array! @messages do |message|
  json.(message, :id, :created_at, :content)
  json.from do
    json.id message.user.id
    # check if we have profile pic
    if message.user.photo.attached?
      json.photo message.user.photo.key
    end
    # get username
    json.username message.user.username
  end
end
