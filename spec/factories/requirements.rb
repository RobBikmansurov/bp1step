FactoryGirl.define do
  factory :requirement do
    label "MyString"
    date Date.current
    duedate Date.current
    source "MyString"
    body "MyText"
    status "MyString"
    result "MyText"
    letter nil
    user nil
  end

end
