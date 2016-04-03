require 'spec_helper'

describe "bproce_workplaces/show" do
  before(:each) do
    @bproce_workplace = assign(:bproce_workplace, stub_model(BproceWorkplace))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
