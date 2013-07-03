# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :directive do
    name 'directive_name'
    title 'directive_title'
	number 'number'
    note 'directive_note'
    body 'directive_body'
    annotation 'directive_annotation'
    approval Time.now
    created_at Time.now
    updated_at Time.now
  end
end
