json.array! @blogs do |blog|
  json.(blog, :id, :title, :slug, :tags, :categories, :claps)

  if blog.photo.attached?
    json.photo do
      json.key blog.photo.key
    end
  end
end
