require 'spec_helper'

describe "roles/show.html.erb" do
  before(:each) do
    @role = assign(:role, stub_model(Role,
      :name => "Name",
      :note => "MyText",
      :b_proc => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
