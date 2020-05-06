json.key_format! camelize: :lower

json.last_mod @last_mod
json.users do
  json.array! @users do |user|
    json.(user, :username)
  end
end