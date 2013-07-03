FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| "#{n}" }
    username      { "name#{id}" }
    email         { "#{username}@example.com" }
    password              "foobar"
    password_confirmation "foobar"
    encrypted_password 'secret'
  end

end
