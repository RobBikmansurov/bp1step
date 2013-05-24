require 'spec_helper'

describe "bproce_bapps/new" do
  before(:each) do
    assign(:bproce_bapp, stub_model(BproceBapp).as_new_record)
  end

  it "renders new bproce_bapp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_bapps_path, "post" do
    end
  end
end
