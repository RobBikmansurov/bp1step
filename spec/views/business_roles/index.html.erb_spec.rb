require 'spec_helper'

describe "business_roles/index.html.erb" do
  before(:each) do
    assign(:business_roles, [
      stub_model(Role,
        :name => "Name",
        :description => "Description"
      ),
      stub_model(Role,
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of business_roles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
