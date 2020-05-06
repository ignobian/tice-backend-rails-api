json.key_format! camelize: :lower

json.user do
  json.(@user, :id, :username, :name, :email, :about, :impressions, :claps, :shares)

  json.followers @user.follower_ids

  # add photo
  if @user.photo.attached?
    json.photo do
      json.key @user.photo.key
    end
  end
end

# user blogs
json.blogs do
  json.array! @user.blogs do |blog|
    json.(blog, :id, :title, :mdesc, :slug, :tags, :categories, :claps)

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