FactoryBot.define do
  factory :merchant do
    name { Faker::Appliance.brand }
  end
end