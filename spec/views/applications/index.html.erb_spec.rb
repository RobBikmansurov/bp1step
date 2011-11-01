require 'spec_helper'

describe "applications/index.html.erb" do
  before(:each) do
    assign(:applications, [
      stub_model(Application,
        :app_name => "App Name",
        :app_type => "App Type",
        :app_note => "App Note"
      ),
      stub_model(Application,
        :app_name => "App Name",
        :app_type => "App Type",
        :app_note => "App Note"
      )
    ])
  end

  it "renders a list of applications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "App Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "App Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "App Note".to_s, :count => 2
  end
end
