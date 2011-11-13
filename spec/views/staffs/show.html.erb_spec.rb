require 'spec_helper'

describe "staffs/show.html.erb" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      :fullname => "Fullname",
      :position => "Position",
      :supervisor => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fullname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Position/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
