FactoryBot.define do
  factory :blog do
    title { Faker::Name.first_name }
    slug { Faker::Internet.slug(words: 'foo bar', glue: '-') }
    body { Faker::Lorem.paragraph(sentence_count: 50) + '<img src="/loading.jpg"><img src="/hello.jpg">' + Faker::Lorem.paragraph(sentence_count: 30) }
    association :user
  end
end