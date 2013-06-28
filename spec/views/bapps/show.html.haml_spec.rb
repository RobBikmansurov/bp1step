require 'spec_helper'

include Devise::TestHelpers

describe "bapps/show.html.haml" do
  before(:each) do
    @bapp = assign(:bapp, stub_model(Bapp,
      :name => "Name",
      :type => "Type",
      :description => "Description",
      created_at: DateTime.now,
      updated_at: DateTime.now
    ))
  end

  it "renders attributes in <p>" do
    assign(:user, stub_model(User))
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
