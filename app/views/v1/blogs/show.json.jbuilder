json.key_format! camelize: :lower

json.(@blog, :id, :title, :slug, :body, :categories, :tags, :keywords, :created_at, :updated_at)
json.claps @blog.claps.count
# user
json.user do
  json.(@blog.user, :followers, :id, :username, :name)
end

# featured image
if @blog.photo.attached?
  json.photo do
    json.(@blog.photo, :key)
  end
end
