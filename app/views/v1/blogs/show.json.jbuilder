json.key_format! camelize: :lower

json.(@blog, :id, :title, :body, :categories, :tags, :keywords, :claps, :created_at, :updated_at)
json.user do
  json.(@blog.user, :followers, :id, :username, :name)
end