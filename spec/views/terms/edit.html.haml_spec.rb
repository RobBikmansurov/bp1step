require 'spec_helper'

describe "terms/edit" do
  before(:each) do
    @term = assign(:term, stub_model(Term,
      :shortname => "MyString",
      :name => "MyString",
      :description => "MyText",
      :note => "MyText",
      :source => "MyText"
    ))
  end

  it "renders the edit term form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", term_path(@term), "post" do
      assert_select "input#term_shortname[name=?]", "term[shortname]"
      assert_select "input#term_name[name=?]", "term[name]"
      assert_select "textarea#term_description[name=?]", "term[description]"
      assert_select "textarea#term_note[name=?]", "term[note]"
      assert_select "textarea#term_source[name=?]", "term[source]"
    end
  end
end
