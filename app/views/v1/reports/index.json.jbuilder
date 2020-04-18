json.key_format! camelize: :lower

json.array! @reports do |report|
  json.(report, :id, :name, :user, :blog)
end