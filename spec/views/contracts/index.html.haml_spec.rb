require 'spec_helper'

describe "contracts/index" do
  before(:each) do
    assign(:contracts, [
      stub_model(Contract,
        :owner_id => nil,
        :number => "Number",
        :name => "Name",
        :status => "Status",
        :description => "MyText",
        :text => "MyText",
        :note => "MyText"
      ),
      stub_model(Contract,
        :owner_id => nil,
        :number => "Number",
        :name => "Name",
        :status => "Status",
        :description => "MyText",
        :text => "MyText",
        :note => "MyText"
      )
    ])
  end

  it "renders a list of contracts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
