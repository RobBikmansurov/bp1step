require 'spec_helper'

describe "document_directives/new" do
  before(:each) do
    assign(:document_directive, stub_model(DocumentDirective,
      :documents => "",
      :directives => "",
      :note => "MyString"
    ).as_new_record)
  end

  it "renders new document_directive form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => document_directives_path, :method => "post" do
      assert_select "input#document_directive_documents", :name => "document_directive[documents]"
      assert_select "input#document_directive_directives", :name => "document_directive[directives]"
      assert_select "input#document_directive_note", :name => "document_directive[note]"
    end
  end
end
