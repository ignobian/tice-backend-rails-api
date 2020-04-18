json.key_format! camelize: :lower

json.(@blog, :id, :title, :slug, :body, :categories, :tags, :mdesc, :excerpt, :keywords, :created_at, :updated_at)
json.claps @blog.claps.count
# user
json.user do
  json.(@blog.user, :followers, :id, :username, :name)
  if @blog.user.photo.attached?
    json.photo do
      json.(@blog.user.photo, :key)
    end
  end
end

# featured image
if @blog.photo.attached?
  json.photo do
    json.(@blog.photo, :key)
  end
end
