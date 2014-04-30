require 'spec_helper'

describe "metrics/show" do
  before(:each) do
    @metric = assign(:metric, stub_model(Metric,
      :bproce => nil,
      :name => "Name",
      :shortname => "Shortname",
      :description => "MyText",
      :note => "MyText",
      :depth => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Shortname/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
  end
end
