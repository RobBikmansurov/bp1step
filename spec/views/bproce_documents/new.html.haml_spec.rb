require 'spec_helper'

describe "bproce_documents/new" do
  before(:each) do
    assign(:bproce_document, stub_model(BproceDocument).as_new_record)
  end

  it "renders new bproce_document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_documents_path, "post" do
    end
  end
end
