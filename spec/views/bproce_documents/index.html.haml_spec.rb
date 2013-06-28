require 'spec_helper'

describe "bproce_documents/index" do
  before(:each) do
    assign(:bproce_documents, [
      stub_model(BproceDocument),
      stub_model(BproceDocument)
    ])
  end

  it "renders a list of bproce_documents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
