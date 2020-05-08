# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(password: 'password', username: 'admin01', role: 'admin', first_name: 'Mr', last_name: 'Admin', email: 'admin@example.com')
# Category.create!(name: 'Next Js', slug: 'next-js')
# Category.create!(name: 'React Js', slug: 'react-js')
# Category.create!(name: 'Node Js', slug: 'node-js')

User.all.each do |user|
  if user.photo.attached?
    Cloudinary::Uploader.upload("http://res.cloudinary.com/ticekralt/image/upload/#{user.photo.key}", public_id: user.photo.key)
  end
end

Blog.all.each do |blog|
  if blog.photo.attached?
    begin
      Cloudinary::Uploader.upload("http://res.cloudinary.com/ticekralt/image/upload/#{blog.photo.key}", public_id: blog.photo.key)
    rescue
      puts "not found"
    end
  end
end