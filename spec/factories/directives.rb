# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :directive do
    sequence(:id) { |n| "#{n}" }
    #name "directive_name #{id}"
    title 'directive_title'
	number "number #{id}"
    note 'directive_note'
    body 'directive_body'
    annotation 'directive_annotation'
    status "Проект"
    approval Time.now
  end
end
