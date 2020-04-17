json.key_format! camelize: :lower

json.(@blog, :id, :title, :body, :categories, :tags, :keywords, :user, :created_at, :updated_at)