require 'spec_helper'

describe "metrics/index" do
  before(:each) do
    assign(:metrics, [
      stub_model(Metric,
        :bproce => nil,
        :name => "Name",
        :shortname => "Shortname",
        :description => "MyText",
        :note => "MyText",
        :depth => 1
      ),
      stub_model(Metric,
        :bproce => nil,
        :name => "Name",
        :shortname => "Shortname",
        :description => "MyText",
        :note => "MyText",
        :depth => 1
      )
    ])
  end

  it "renders a list of metrics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Shortname".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
