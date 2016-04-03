require 'spec_helper'

describe "bproce_iresources/edit" do
  before(:each) do
    @bproce_iresource = assign(:bproce_iresource, stub_model(BproceIresource))
  end

  it "renders the edit bproce_iresource form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_iresource_path(@bproce_iresource), "post" do
    end
  end
end
