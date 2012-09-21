require 'spec_helper'

describe "directives/new" do
  before(:each) do
    assign(:directive, stub_model(Directive,
      :title => "MyString",
      :number => "MyString",
      :name => "MyString",
      :note => "MyString",
      :body => "MyString"
    ).as_new_record)
  end

  it "renders new directive form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => directives_path, :method => "post" do
      assert_select "input#directive_title", :name => "directive[title]"
      assert_select "input#directive_number", :name => "directive[number]"
      assert_select "input#directive_name", :name => "directive[name]"
      assert_select "input#directive_note", :name => "directive[note]"
      assert_select "input#directive_body", :name => "directive[body]"
    end
  end
end
