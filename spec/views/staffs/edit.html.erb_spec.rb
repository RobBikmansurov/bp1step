require 'spec_helper'

describe "staffs/edit.html.erb" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      :fullname => "MyString",
      :position => "MyString",
      :supervisor => false
    ))
  end

  it "renders the edit staff form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staffs_path(@staff), :method => "post" do
      assert_select "input#staff_fullname", :name => "staff[fullname]"
      assert_select "input#staff_position", :name => "staff[position]"
      assert_select "input#staff_supervisor", :name => "staff[supervisor]"
    end
  end
end
