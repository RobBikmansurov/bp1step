FactoryGirl.define do
  factory :user_role do
    user_id = FactoryGirl.build(:user)
    role_id = FactoryGirl.build(:role)
    name 'user'
    description 'user_role_description'
  end
end