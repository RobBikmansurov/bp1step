FactoryGirl.define do
  factory :bproce do
    sequence(:id) { |n| "#{n}" }
    name { "bproce_name_#{id}" }
    shortname { "bp.#{id}" }
    fullname 'test process full name'
  end
end