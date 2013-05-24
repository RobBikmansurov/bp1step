require 'spec_helper'

describe "bproce_workplaces/edit" do
  before(:each) do
    @bproce_workplace = assign(:bproce_workplace, stub_model(BproceWorkplace))
  end

  it "renders the edit bproce_workplace form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bproce_workplace_path(@bproce_workplace), "post" do
    end
  end
end
