require 'spec_helper'

describe "categories/edit.html.haml" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :cat_table => "MyString",
      :cat_type => "MyString",
      :cat_name => "MyString",
      :sortorder => 1
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => categories_path(@category), :method => "post" do
      assert_select "input#category_cat_table", :name => "category[cat_table]"
      assert_select "input#category_cat_type", :name => "category[cat_type]"
      assert_select "input#category_cat_name", :name => "category[cat_name]"
      assert_select "input#category_sortorder", :name => "category[sortorder]"
    end
  end
end
