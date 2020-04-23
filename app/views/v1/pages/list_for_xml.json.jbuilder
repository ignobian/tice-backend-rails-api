json.blogs do
  json.array! @blogs do |blog|
    json.(blog, :slug, :updated_at)
  end

  json.array! @categories do |category|
    json.(category, :slug)
  end

  json.array! @tags do |tag|
    json.(tag, :slug)
  end

  json.array! @users do |user|
    json.(user, :username)
  end
end