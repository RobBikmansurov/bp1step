FactoryGirl.define do
  factory :term do
    sequence(:id) { |n| "#{n}" }
    name      { "name#{id}" }
    shortname      { "shortname#{id}" }
    description 'test_description'
  end
end