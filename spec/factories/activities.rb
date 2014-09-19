FactoryGirl.define do
	factory :activity do
    activity_type
    customer
    user
    date "2013-06-12"
    duration 1
    description "MyText"
    project_id 1
    redmine_ticket_id 1
    otrs_ticket_id 1
  end
end