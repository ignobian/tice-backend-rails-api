json.key_format! camelize: :lower

json.array! @users do |user|
  json.(user, :id, :username, :name, :blogs)

  json.impressions user.impressions.count
  json.shares user.shares.count
  json.claps user.claps.count

  if user.photo.attached?
    json.photo do
      json.key user.photo.key
    end
  end
end