json.array! @categories do |category|
  json.(category, :name, :slug, :id)
end