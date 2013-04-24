require 'spec_helper'

describe "terms/show" do
  before(:each) do
    @term = assign(:term, stub_model(Term,
      :shortname => "Shortname",
      :name => "Name",
      :description => "MyText",
      :note => "MyText",
      :source => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Shortname/)
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
