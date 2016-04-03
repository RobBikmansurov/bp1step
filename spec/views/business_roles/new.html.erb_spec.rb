require 'spec_helper'

describe "business_roles/new.html.haml" do
  before(:each) do
    assign(:business_role, stub_model(BusinessRole,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new business_role form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => business_roles_path, :method => "post" do
      assert_select "input#business_role_name", :name => "business_role[name]"
      assert_select "input#business_role_description", :name => "business_role[description]"
    end
  end
end
