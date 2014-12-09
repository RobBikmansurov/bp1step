# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :directive do
    sequence(:name) { |n| "directive_name#{n}" }
    number "number"
    approval Time.now
    body "Орган"
    status "Проект"
  end
end
