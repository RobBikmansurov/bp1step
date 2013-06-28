require 'spec_helper'

describe "bapps/new.html.erb" do
  before(:each) do
    assign(:bapp, stub_model(Bapp,
      :name => "MyString",
      :type => "",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new bapp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bapps_path, :method => "post" do
      assert_select "input#bapp_name", :name => "bapp[name]"
      assert_select "input#bapp_type", :name => "bapp[type]"
      assert_select "input#bapp_description", :name => "bapp[description]"
    end
  end
end
