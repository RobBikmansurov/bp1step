require 'spec_helper'

describe "bproce_workplaces/index" do
  before(:each) do
    assign(:bproce_workplaces, [
      stub_model(BproceWorkplace),
      stub_model(BproceWorkplace)
    ])
  end

  it "renders a list of bproce_workplaces" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
