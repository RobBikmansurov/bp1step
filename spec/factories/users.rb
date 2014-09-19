FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| "#{n}" }
    sequence(:username) { |n| "Person #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com"}
    displayname	  { "displayname#{id}" }
    lastname      { "lastname#{id}" }
    firstname     { "firstname#{id}" }
    password              "password"
    password_confirmation "password"
    encrypted_password 'secret'
    last_sign_in_at '2014-09-19'
  end
end
