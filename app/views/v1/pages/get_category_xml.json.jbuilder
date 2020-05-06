json.key_format! camelize: :lower

json.array! @blogs do |blog|
  json.(blog, :slug, :updated_at)
end