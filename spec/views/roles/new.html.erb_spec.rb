require 'spec_helper'

describe "roles/new.html.erb" do
  before(:each) do
    assign(:role, stub_model(Role,
      :name => "MyString",
      :note => "MyText",
      :b_proc => nil
    ).as_new_record)
  end

  it "renders new role form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => roles_path, :method => "post" do
      assert_select "input#role_name", :name => "role[name]"
      assert_select "textarea#role_note", :name => "role[note]"
      assert_select "input#role_b_proc", :name => "role[b_proc]"
    end
  end
end
