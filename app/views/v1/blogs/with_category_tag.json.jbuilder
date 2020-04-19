json.blogs do
  json.array! @blogs do |blog|
    json.(blog, :id, :title, :slug, :tags, :categories, :claps)

    json.user do
      json.(blog.user, :id, :name, :username)

      json.followers user.follower_ids

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

json.categories do
  json.array! @categories do |category|
    json.(category, :id, :name, :slug)
  end
end

json.tags do
  json.array! @tags do |tag|
    json.(tag, :id, :name, :slug)
  end
end

json.size Blog.count
