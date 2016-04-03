FactoryGirl.define do
  factory :letter do
    sequence(:id)  { |n| "#{n}" }
    number         { "LET--#{id}" }

   regnumber "MyString"
  regdate "2015-06-24"
  number "MyString"
  date "2015-06-24"
subject "MyString"
source "MyString"
sender "MyText"
body "MyText"
status 1
result "MyText"
letter nil
  end

end
