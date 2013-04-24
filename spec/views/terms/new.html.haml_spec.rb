require 'spec_helper'

describe "terms/new" do
  before(:each) do
    assign(:term, stub_model(Term,
      :shortname => "MyString",
      :name => "MyString",
      :description => "MyText",
      :note => "MyText",
      :source => "MyText"
    ).as_new_record)
  end

  it "renders new term form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", terms_path, "post" do
      assert_select "input#term_shortname[name=?]", "term[shortname]"
      assert_select "input#term_name[name=?]", "term[name]"
      assert_select "textarea#term_description[name=?]", "term[description]"
      assert_select "textarea#term_note[name=?]", "term[note]"
      assert_select "textarea#term_source[name=?]", "term[source]"
    end
  end
end
