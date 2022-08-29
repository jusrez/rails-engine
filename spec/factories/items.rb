FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Cannabis.strain }
    description { Faker::Cannabis.health_benefit }
    unit_price {Faker::Number.decimal(l_digits: 2)}
  end
end