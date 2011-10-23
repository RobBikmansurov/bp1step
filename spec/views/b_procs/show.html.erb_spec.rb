require 'spec_helper'

describe "b_procs/show.html.erb" do
  before(:each) do
    @b_proc = assign(:b_proc, stub_model(BProc,
      :ptitle => "Ptitle",
      :pbody => "MyText",
      :pcode => "Pcode"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ptitle/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Pcode/)
  end
end
