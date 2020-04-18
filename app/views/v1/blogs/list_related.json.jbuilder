json.key_format! camelize: :lower

json.array! @blog.related do |blog|
  json.(blog, :id, :title, :excerpt, :slug, :claps, :user, :created_at, :updated_at)

  if blog.photo.attached?
    json.photo do
      json.key blog.photo.key
    end
  end
end
