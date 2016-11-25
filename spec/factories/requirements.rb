FactoryGirl.define do
  factory :requirement do
    sequence(:id) { |n| "#{n}" }
    label         { "requirement#{id}" }
    date Date.current
    duedate Date.current
    source "MyString"
    body "MyText"
    status "MyString"
    result "MyText"
  end

end
