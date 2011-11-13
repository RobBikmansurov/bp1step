require 'spec_helper'

describe "workplaces/index.html.erb" do
  before(:each) do
    assign(:workplaces, [
      stub_model(Workplace,
        :designation => "Designation",
        :name => "Name",
        :description => "Description",
        :typical => false,
        :location => "Location"
      ),
      stub_model(Workplace,
        :designation => "Designation",
        :name => "Name",
        :description => "Description",
        :typical => false,
        :location => "Location"
      )
    ])
  end

  it "renders a list of workplaces" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Designation".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Location".to_s, :count => 2
  end
end
