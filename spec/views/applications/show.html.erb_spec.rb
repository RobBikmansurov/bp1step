require 'spec_helper'

describe "applications/show.html.erb" do
  before(:each) do
    @application = assign(:application, stub_model(Application,
      :app_name => "App Name",
      :app_type => "App Type",
      :app_note => "App Note"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/App Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/App Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/App Note/)
  end
end
