require 'spec_helper'

describe "contracts/show" do
  before(:each) do
    @contract = assign(:contract, stub_model(Contract,
      :owner_id => nil,
      :number => "Number",
      :name => "Name",
      :status => "Status",
      :description => "MyText",
      :text => "MyText",
      :note => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Number/)
    rendered.should match(/Name/)
    rendered.should match(/Status/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
