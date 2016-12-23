FactoryGirl.define do
  factory :agent do
    sequence(:id)  { |n| "#{n}" }
    name           { "agent-#{id}" }
  end

end
