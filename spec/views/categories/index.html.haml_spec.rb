require 'spec_helper'

describe "categories/index.html.haml" do
  before(:each) do
    assign(:categories, [
      stub_model(Category,
        :cat_table => "Cat Table",
        :cat_type => "Cat Type",
        :cat_name => "Cat Name",
        :sortorder => 1
      ),
      stub_model(Category,
        :cat_table => "Cat Table",
        :cat_type => "Cat Type",
        :cat_name => "Cat Name",
        :sortorder => 1
      )
    ])
  end

  it "renders a list of categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cat Table".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cat Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cat Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
