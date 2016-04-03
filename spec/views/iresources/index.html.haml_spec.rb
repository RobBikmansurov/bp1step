require 'spec_helper'

describe "iresources/index" do
  before(:each) do
    assign(:iresources, [
      stub_model(Iresource,
        :level => "Level",
        :label => "Label",
        :location => "Location",
        :volume => 1,
        :note => "MyText",
        :access_read => "Access Read",
        :access_write => "Access Write",
        :access_other => "Access Other",
        :users => nil
      ),
      stub_model(Iresource,
        :level => "Level",
        :label => "Label",
        :location => "Location",
        :volume => 1,
        :note => "MyText",
        :access_read => "Access Read",
        :access_write => "Access Write",
        :access_other => "Access Other",
        :users => nil
      )
    ])
  end

  it "renders a list of iresources" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Level".to_s, :count => 2
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Access Read".to_s, :count => 2
    assert_select "tr>td", :text => "Access Write".to_s, :count => 2
    assert_select "tr>td", :text => "Access Other".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
