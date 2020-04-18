json.array! @users do |user|
  json.(user, :id, :username, :name)

  json.impressions user.impressions.count
  json.shares user.shares.count
  json.claps user.claps.count

  if user.photo.attached?
    json.photo do
      json.key user.photo.key
    end
  end
end