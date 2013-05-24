require 'spec_helper'

describe "documents/new" do
  before(:each) do
    assign(:document, stub_model(Document).as_new_record)
  end

  it "renders new document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", documents_path, "post" do
    end
  end
end
