require 'spec_helper'

describe "bproces/show.html.erb" do
  before(:each) do
    @bproce = assign(:bproce, stub_model(Bproce,
      :shortname => "Shortname",
      :name => "Name",
      :fullname => "Fullname"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Shortname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fullname/)
  end
end
