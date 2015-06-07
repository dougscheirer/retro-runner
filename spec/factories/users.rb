require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "notsecureuser"
    password_confirmation "notsecureuser"
    name { Faker::Name.name }
    admin false
  end
end
