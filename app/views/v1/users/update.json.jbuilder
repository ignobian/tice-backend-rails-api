json.message 'User successfully updated'
json.user do
  json.(@user, :id, :full_name, :email, :username)
  if @user.photo.attached?
    json.photo do
      json.key @user.photo.key
    end
  end
end