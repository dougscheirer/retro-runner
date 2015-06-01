FactoryGirl.define do
  factory :admin_user do
    email "admin@example.com"
    password "notsecure"
    password_confirmation "notscure"
    name "admin"
    admin true
  end

  factory :user do
    email "user@example.com"
    password "notsecureuser"
    password_confirmation "notsecureuser"
    name "user"
    admin false
  end

end
