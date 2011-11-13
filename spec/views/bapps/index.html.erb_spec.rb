require 'spec_helper'

describe "bapps/index.html.erb" do
  before(:each) do
    assign(:bapps, [
      stub_model(Bapp,
        :name => "Name",
        :type => "Type",
        :description => "Description"
      ),
      stub_model(Bapp,
        :name => "Name",
        :type => "Type",
        :description => "Description"
      )
    ])
  end

  it "renders a list of bapps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
