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

