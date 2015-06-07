FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    owner_id 1
  end
end
