FactoryGirl.define do
  factory :role do
    #name 'test_role_name'
    sequence :name do |n|
      "name#{n}_test"
  	end
    description 'test_role_description'
  end
  factory :role_user do
  	id 1
    name 'user'
    description 'user_role_description'
  end
end