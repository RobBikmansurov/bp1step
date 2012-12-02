FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "foo#{n}" }
    password "foobar"
    email { "#{username}@example.com" }
    password_confirmation "foobar"
  end

  factory :user_user do
    sequence(:username) { |n| "foo#{n}" }
    password "foobar"
    email { "#{username}@example.com" }
    password_confirmation "foobar"
    roles_ids [1]
  end
  
end
