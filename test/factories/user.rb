FactoryBot.define do
  factory :user do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    role { 0 }

    transient do
      blogs { 1 }
    end

    after(:create) do |user, evaluator|
      create_list(:blogs, evaluator.blogs, user: user)
    end
  end
end