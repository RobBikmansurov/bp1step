FactoryGirl.define do
  factory :letter do
    sequence(:id)  { |n| "#{n}" }
    number         { "LET--#{id}" }
    regnumber "MyString"
    regdate Date.current
    number "MyString"
    date Date.current
    subject "MyString"
    source "MyString"
    sender "MyText"
    body "MyText"
    status 1
    result "MyText"
  end

end
