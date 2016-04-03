require 'spec_helper'

describe "document_directives/index" do
  before(:each) do
    assign(:document_directives, [
      stub_model(DocumentDirective,
        :documents => "",
        :directives => "",
        :note => "Note"
      ),
      stub_model(DocumentDirective,
        :documents => "",
        :directives => "",
        :note => "Note"
      )
    ])
  end

  it "renders a list of document_directives" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
  end
end
