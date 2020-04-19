json.array! @users do |user|
  json.(user, :id, :name, :username)

  if user.photo.attached?
    json.photo do
      json.key user.photo.key
    end
  end
end