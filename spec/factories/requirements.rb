FactoryGirl.define do
  factory :requirement do
    label "MyString"
date "2015-06-30"
duedate "2015-06-30"
source "MyString"
body "MyText"
status "MyString"
result "MyText"
letter nil
user nil
  end

end
