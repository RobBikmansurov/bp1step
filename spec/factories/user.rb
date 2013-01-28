FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "name#{n}" }
    password "foobar"
    email { "#{username}@example.com" }
    password_confirmation "foobar"
  end

  factory :auth_user do
    sequence(:username) { |n| "name#{n}" }
    password "foobar"
    email { "#{username}@example.com" }
    password_confirmation "foobar"
    roles_ids [1]
  end
  
end
