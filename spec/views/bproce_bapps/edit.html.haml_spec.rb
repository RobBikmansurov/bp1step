require 'spec_helper'

describe "bproce_bapps/edit" do
  before(:each) do
    @bproce_bapp = assign(:bproce_bapp, stub_model(BproceBapp))
  end

  it "renders the edit bproce_bapp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_bapp_path(@bproce_bapp), "post" do
    end
  end
end
