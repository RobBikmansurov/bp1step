require 'rails_helper'

RSpec.describe "requirements/edit", :type => :view do
  before(:each) do
    @requirement = assign(:requirement, Requirement.create!(
      :label => "MyString",
      :source => "MyString",
      :body => "MyText",
      :status => "MyString",
      :result => "MyText",
      :letter => nil,
      :user => nil
    ))
  end

  it "renders the edit requirement form" do
    render

    assert_select "form[action=?][method=?]", requirement_path(@requirement), "post" do

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
