json.key_format! camelize: :lower

json.(@user, :id, :username, :first_name, :last_name, :email, :about)

# add photo
if @user.photo.attached?
  json.photo do
    json.key @user.photo.key
  end
end