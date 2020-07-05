json.key_format! camelize: :lower

json.conversation_user do
  json.(@conversation_user, :id, :username, :email)

  json.last_seen @last_seen

  # photo
  if @user.photo.attached?
    json.photo do
      json.key @user.photo.key
    end
  end
end

json.messages do
  json.array! @messages do |message|
    json.(message, :created_at, :content)
    json.from do
      # check if we have profile pic
      if message.user.photo.attached?
        json.photo message.user.photo.key
      end
      # get username
      json.username message.user.username
    end
  end
end