require 'spec_helper'

describe "bproces/index.html.erb" do
  before(:each) do
    assign(:bproces, [
      stub_model(Bproce,
        :shortname => "Shortname",
        :name => "Name",
        :fullname => "Fullname"
      ),
      stub_model(Bproce,
        :shortname => "Shortname",
        :name => "Name",
        :fullname => "Fullname"
      )
    ])
  end

  it "renders a list of bproces" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Shortname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fullname".to_s, :count => 2
  end
end
