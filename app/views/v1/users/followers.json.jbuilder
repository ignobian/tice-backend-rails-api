json.array! @users do |user|
  json.(user, :id, :name, :username)

  json.followers user.follower_ids

  if user.photo.attached?
    json.photo do
      json.key user.photo.key
    end
  end
end
