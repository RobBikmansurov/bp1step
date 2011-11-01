require 'spec_helper'

describe "applications/new.html.erb" do
  before(:each) do
    assign(:application, stub_model(Application,
      :app_name => "MyString",
      :app_type => "MyString",
      :app_note => "MyString"
    ).as_new_record)
  end

  it "renders new application form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => applications_path, :method => "post" do
      assert_select "input#application_app_name", :name => "application[app_name]"
      assert_select "input#application_app_type", :name => "application[app_type]"
      assert_select "input#application_app_note", :name => "application[app_note]"
    end
  end
end
