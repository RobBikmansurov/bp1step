require 'spec_helper'

describe "bproce_documents/show" do
  before(:each) do
    @bproce_document = assign(:bproce_document, stub_model(BproceDocument))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
