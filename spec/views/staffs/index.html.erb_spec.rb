require 'spec_helper'

describe "staffs/index.html.erb" do
  before(:each) do
    assign(:staffs, [
      stub_model(Staff,
        :fullname => "Fullname",
        :position => "Position",
        :supervisor => false
      ),
      stub_model(Staff,
        :fullname => "Fullname",
        :position => "Position",
        :supervisor => false
      )
    ])
  end

  it "renders a list of staffs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fullname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Position".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
