require 'spec_helper'

describe "b_procs/index.html.erb" do
  before(:each) do
    assign(:b_procs, [
      stub_model(BProc,
        :ptitle => "Ptitle",
        :pbody => "MyText",
        :pcode => "Pcode"
      ),
      stub_model(BProc,
        :ptitle => "Ptitle",
        :pbody => "MyText",
        :pcode => "Pcode"
      )
    ])
  end

  it "renders a list of b_procs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ptitle".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Pcode".to_s, :count => 2
  end
end
