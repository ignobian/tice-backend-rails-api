json.key_format! camelize: :lower

json.following @user.followings.count

json.blogs do

  json.array! @blogs do |blog|
    json.(blog, :id, :title, :slug, :tags, :categories, :claps)

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
