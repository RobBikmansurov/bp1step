require 'rails_helper'

RSpec.describe "requirements/new", :type => :view do
  before(:each) do
    assign(:requirement, Requirement.new(
      :label => "MyString",
      :source => "MyString",
      :body => "MyText",
      :status => "MyString",
      :result => "MyText",
      :letter => nil,
      :user => nil
    ))
  end

  it "renders new requirement form" do
    render

    assert_select "form[action=?][method=?]", requirements_path, "post" do

      assert_select "input#requirement_label[name=?]", "requirement[label]"

      assert_select "input#requirement_source[name=?]", "requirement[source]"

      assert_select "textarea#requirement_body[name=?]", "requirement[body]"

      assert_select "input#requirement_status[name=?]", "requirement[status]"

      assert_select "textarea#requirement_result[name=?]", "requirement[result]"

      assert_select "input#requirement_letter_id[name=?]", "requirement[letter_id]"

      assert_select "input#requirement_user_id[name=?]", "requirement[user_id]"
    end
  end
end
