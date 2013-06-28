require 'spec_helper'

describe "bproce_documents/edit" do
  before(:each) do
    @bproce_document = assign(:bproce_document, stub_model(BproceDocument))
  end

  it "renders the edit bproce_document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_document_path(@bproce_document), "post" do
    end
  end
end
