require 'spec_helper'

describe "directives/show" do
  before(:each) do
    @directive = assign(:directive, stub_model(Directive,
      :title => "Title",
      :number => "Number",
      :name => "Name",
      :note => "Note",
      :body => "Body"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Number/)
    rendered.should match(/Name/)
    rendered.should match(/Note/)
    rendered.should match(/Body/)
  end
end
