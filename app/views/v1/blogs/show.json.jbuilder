json.key_format! camelize: :lower

json.(@blog, :id, :title, :slug, :body, :categories, :tags, :keywords, :created_at, :updated_at)
json.claps @blog.claps.count
json.user do
  json.(@blog.user, :followers, :id, :username, :name)
end