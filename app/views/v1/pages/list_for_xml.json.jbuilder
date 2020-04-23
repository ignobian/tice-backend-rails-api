json.key_format! camelize: :lower

json.blogs do
  json.array! @blogs do |blog|
    json.(blog, :slug, :updated_at)
  end
end

json.categories do
  json.array! @categories do |category|
    json.(category, :slug)
  end
end

json.tags do
  json.array! @tags do |tag|
    json.(tag, :slug)
  end
end

json.users do
  json.array! @users do |user|
    json.(user, :username)
  end
end
