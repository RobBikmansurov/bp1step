require 'spec_helper'

describe "business_roles/edit.html.erb" do
  before(:each) do
    @business_role = assign(:business_role, stub_model(Role,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit business_role form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => business_roles_path(@business_role), :method => "post" do
      assert_select "input#business_role_name", :name => "business_role[name]"
      assert_select "input#business_role_description", :name => "business_role[description]"
    end
  end
end
