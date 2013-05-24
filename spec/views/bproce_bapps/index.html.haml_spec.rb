require 'spec_helper'

describe "bproce_bapps/index" do
  before(:each) do
    assign(:bproce_bapps, [
      stub_model(BproceBapp),
      stub_model(BproceBapp)
    ])
  end

  it "renders a list of bproce_bapps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
