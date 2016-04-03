require 'spec_helper'

describe "categories/show.html.haml" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :cat_table => "Cat Table",
      :cat_type => "Cat Type",
      :cat_name => "Cat Name",
      :sortorder => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cat Table/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cat Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cat Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
