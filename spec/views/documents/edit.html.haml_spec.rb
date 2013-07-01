require 'spec_helper'

describe "documents/edit.html.haml" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :name => "MyString",
      :filename => "MyString",
      :description => "MyString",
      :status => "MyString",
      :part => "MyString",
      :place => "MyString"
    ))
  end

  it "renders the edit document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => documents_path(@document), :method => "post" do
      assert_select "input#document_name", :name => "document[name]"
      assert_select "input#document_filename", :name => "document[filename]"
      assert_select "input#document_description", :name => "document[description]"
      assert_select "input#document_status", :name => "document[status]"
      assert_select "input#document_part", :name => "document[part]"
      assert_select "input#document_place", :name => "document[place]"
    end
  end
end
