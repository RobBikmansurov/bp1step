FactoryGirl.define do
  factory :user_role do
    sequence(:id) { |n| "#{n}" }
    user_id { FactoryGirl.build(:user) }
    role_id { FactoryGirl.build(:role) }
    note 'user_role'
  end
end
