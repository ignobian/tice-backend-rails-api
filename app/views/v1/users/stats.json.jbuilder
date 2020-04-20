json.key_format! camelize: :lower

json.stats do
  json.total_views @user.impressions.count
  json.total_shares @user.shares.count
end

json.blogs do
  json.array! @user.blogs do |blog|
    json.impression_length blog.impressions.count
    json.shares_length blog.shares.count
    json.(blog, :id, :title, :slug, :impressions, :shares)

    if blog.photo.attached?
      json.photo do
        json.key blog.photo.key
      end
    end
  end
end
