json.key_format! camelize: :lower

json.user do
  json.(@user, :id, :full_name, :username, :email, :role)
end

json.token @token