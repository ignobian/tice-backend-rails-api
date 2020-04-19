json.array! @tags do |tag|
  json.(tag, :id, :name, :slug, :blog_count)
end
