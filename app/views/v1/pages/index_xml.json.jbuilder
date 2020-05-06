json.key_format! camelize: :lower

json.last_mod @last_mod

json.categories do
  json.array! @categories do |cat|
    json.(cat, :slug, :last_modified)
  end
end
