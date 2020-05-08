json.key_format! camelize: :lower

json.category do
  json.(@category, :id, :name, :slug)
end

json.blogs do
  json.array! @category.blogs do |blog|
    json.(blog, :id, :title, :slug, :mdesc, :tags, :categories, :claps, :updated_at)

    json.user do
      json.(blog.user, :id, :name, :username)

      json.followers blog.user.follower_ids

      if blog.user.photo.attached?
        json.photo do
          json.key blog.user.photo.key
        end
      end
    end

    if blog.photo.attached?
      json.photo do
        json.key blog.photo.key
      end
    end

  end
end