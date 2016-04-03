require 'spec_helper'

describe "document_directives/show" do
  before(:each) do
    @document_directive = assign(:document_directive, stub_model(DocumentDirective,
      :documents => "",
      :directives => "",
      :note => "Note"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Note/)
  end
end
