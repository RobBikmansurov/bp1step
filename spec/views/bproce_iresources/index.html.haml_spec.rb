require 'spec_helper'

describe "bproce_iresources/index" do
  before(:each) do
    assign(:bproce_iresources, [
      stub_model(BproceIresource),
      stub_model(BproceIresource)
    ])
  end

  it "renders a list of bproce_iresources" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
