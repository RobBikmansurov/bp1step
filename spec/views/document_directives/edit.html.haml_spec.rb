require 'spec_helper'

describe "document_directives/edit" do
  before(:each) do
    @document_directive = create(:document_directive)
  end

  it "renders the edit document_directive form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => document_directives_path(@document_directive), :method => "post" do
      assert_select "input#document_directive_document", :name => "document_directive[documents]"
      assert_select "input#document_directive_directive", :name => "document_directive[directives]"
      assert_select "input#document_directive_note", :name => "document_directive[note]"
    end
  end
end
