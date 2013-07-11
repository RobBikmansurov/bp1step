FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| "#{n}" }
    email         { "#{username}@example.com" }
    displayname	  { "displayname#{id}" }
    lastname      { "lastname#{id}" }
    firstname     { "firstname#{id}" }
    password              "foobar"
    password_confirmation "foobar"
    encrypted_password 'secret'
    username      { "name#{id}" }
  end
end
