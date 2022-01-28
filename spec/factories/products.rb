FactoryBot.define do
  factory :product do
    title { 'Nice Product' }
    price { 9.99 }
    published { false }
    user { association(:user) }
  end
end
