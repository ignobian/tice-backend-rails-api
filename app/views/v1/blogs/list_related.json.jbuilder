json.key_format! camelize: :lower

json.array! @blog.related do |blog|
  json.(blog, :id, :title, :excerpt, :slug, :mdesc, :claps, :created_at, :updated_at)

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
