FactoryGirl.define do
  factory :role do
    #name 'test_role_name'
    sequence :name do |n|
      "name#{n}_test"
  	end
    description 'test_role_description'
  end

end