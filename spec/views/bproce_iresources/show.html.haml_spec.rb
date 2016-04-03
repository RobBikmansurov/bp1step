require 'spec_helper'

describe "bproce_iresources/show" do
  before(:each) do
    @bproce_iresource = assign(:bproce_iresource, stub_model(BproceIresource))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
