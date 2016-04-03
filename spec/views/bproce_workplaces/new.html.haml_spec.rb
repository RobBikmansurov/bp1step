require 'spec_helper'

describe "bproce_workplaces/new" do
  before(:each) do
    assign(:bproce_workplace, stub_model(BproceWorkplace).as_new_record)
  end

  it "renders new bproce_workplace form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_workplaces_path, "post" do
    end
  end
end
