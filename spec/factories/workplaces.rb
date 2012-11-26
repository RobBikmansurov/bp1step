# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :workplace do
    name 'workplace_name'
    description "Workplace description"
    designation "WorkplaceDesignation"
  end
end
