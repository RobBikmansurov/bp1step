FactoryGirl.define do
  factory :workplace do
  	sequence(:name) { |n| "workplace#{n}" }
    description { "Workplace description" }
    designation { "WorkplaceDesignation#{name}" }
  end
end
