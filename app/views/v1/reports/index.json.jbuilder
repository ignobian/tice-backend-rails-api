json.key_format! camelize: :lower

json.array! @reports do |report|
  json.(report, :id, :name)

  json.user do
    json.(report.user, :username)

    if report.user.photo.attached?
      json.photo do
        json.key report.user.photo.key
      end
    end
  end

  json.blog do
    json.(report.blog, :title, :slug)

    if report.blog.photo.attached?
      json.photo do
        json.key report.blog.photo.key
      end
    end

    json.user do
      json.(report.blog.user, :id, :username)

      if report.blog.user.photo.attached?
        json.photo do
          json.key report.blog.user.photo.key
        end
      end
    end
  end
end
