json.key_format! camelize: :lower

json.(@blog, :id, :title, :slug, :body, :tags, :mdesc, :excerpt, :keywords, :created_at, :updated_at)
json.claps @blog.claps.count

json.categories do
  json.array! @blog.categories do |category|
    json.(category, :id, :name, :slug)
  end
end

# featured image
if @blog.photo.attached?
  json.photo do
    json.key @blog.photo.key
  end
end

# user
json.user do
  json.(@blog.user, :followers, :id, :username, :name)

  json.followers @blog.user.follower_ids

  if @blog.user.photo.attached?
    json.photo do
      json.(@blog.user.photo, :key)
    end
  end
end

