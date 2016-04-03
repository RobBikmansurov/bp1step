require 'spec_helper'

describe "bapps/edit.html.erb" do
  before(:each) do
    @bapp = assign(:bapp, stub_model(Bapp,
      :name => "MyString",
      :type => "",
      :description => "MyString"
    ))
  end

  it "renders the edit bapp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bapps_path(@bapp), :method => "post" do
      assert_select "input#bapp_name", :name => "bapp[name]"
      assert_select "input#bapp_type", :name => "bapp[type]"
      assert_select "input#bapp_description", :name => "bapp[description]"
    end
  end
end
