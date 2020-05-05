json.key_format! camelize: :lower

json.user do
  json.(@user, :id, :name, :username, :email, :role)
  if @user.photo.attached?
    json.photo do
      json.key @user.photo.key
    end
  end
end

json.token @token