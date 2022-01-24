FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :existed_user, class: User do
    email { 'existed_user@email.com' }
    password { Faker::Internet.password }
  end
end
