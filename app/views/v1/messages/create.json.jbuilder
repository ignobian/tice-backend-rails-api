json.message do
  json.(@message, :id, :content)

  json.user do
    json.username @message.user.username

    if @message.user.photo.attached?
      json.photo @message.user.photo.key
    end
  end
end