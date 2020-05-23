json.key_format! camelize: :lower

json.stats do
  json.total_claps @user.claps.count
  json.total_views @user.impressions.count
  json.total_shares @user.shares.count
end

json.blogs do
  json.array! @user.blogs do |blog|
    json.impressions blog.impressions.count
    json.shares blog.shares.count
    json.claps blog.claps.count
    json.(blog, :id, :title, :slug)

    if blog.photo.attached?
      json.photo do
        json.key blog.photo.key
      end
    end
  end
end
