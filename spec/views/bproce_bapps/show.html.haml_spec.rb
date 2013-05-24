require 'spec_helper'

describe "bproce_bapps/show" do
  before(:each) do
    @bproce_bapp = assign(:bproce_bapp, stub_model(BproceBapp))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
