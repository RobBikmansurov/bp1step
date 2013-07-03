# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :document do
    name 'document_name'
    bproce_id 1
    dlevel 1
    place 'office1'
    part 1
    owner_id 1
    created_at Time.now
    updated_at Time.now
  end
end
