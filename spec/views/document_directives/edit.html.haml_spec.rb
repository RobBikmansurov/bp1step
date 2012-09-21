require 'spec_helper'

describe "document_directives/edit" do
  before(:each) do
    @document_directive = assign(:document_directive, stub_model(DocumentDirective,
      :documents => "",
      :directives => "",
      :note => "MyString"
    ))
  end

  it "renders the edit document_directive form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => document_directives_path(@document_directive), :method => "post" do
      assert_select "input#document_directive_documents", :name => "document_directive[documents]"
      assert_select "input#document_directive_directives", :name => "document_directive[directives]"
      assert_select "input#document_directive_note", :name => "document_directive[note]"
    end
  end
end
