require 'spec_helper'

describe "iresources/show" do
  before(:each) do
    @iresource = assign(:iresource, stub_model(Iresource,
      :level => "Level",
      :label => "Label",
      :location => "Location",
      :volume => 1,
      :note => "MyText",
      :access_read => "Access Read",
      :access_write => "Access Write",
      :access_other => "Access Other",
      :users => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Level/)
    rendered.should match(/Label/)
    rendered.should match(/Location/)
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/Access Read/)
    rendered.should match(/Access Write/)
    rendered.should match(/Access Other/)
    rendered.should match(//)
  end
end
