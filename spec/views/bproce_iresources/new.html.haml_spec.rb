require 'spec_helper'

describe "bproce_iresources/new" do
  before(:each) do
    assign(:bproce_iresource, stub_model(BproceIresource).as_new_record)
  end

  it "renders new bproce_iresource form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_iresources_path, "post" do
    end
  end
end
