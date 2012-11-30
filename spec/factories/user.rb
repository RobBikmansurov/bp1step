FactoryGirl.define do
  factory :user do
    name  "MarkBrown"
    sequence(:username) { |n| "foo#{n}" }
    password "foobar"
    email { "#{username}@example.com" }
    password_confirmation "foobar"

    
    factory :admin do
      admin true
    end
  end
  
  factory :article do
    name "Foo"
    user
  end
end
