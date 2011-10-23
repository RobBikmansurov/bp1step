require 'spec_helper'

describe "b_procs/new.html.erb" do
  before(:each) do
    assign(:b_proc, stub_model(BProc,
      :ptitle => "MyString",
      :pbody => "MyText",
      :pcode => "MyString"
    ).as_new_record)
  end

  it "renders new b_proc form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => b_procs_path, :method => "post" do
      assert_select "input#b_proc_ptitle", :name => "b_proc[ptitle]"
      assert_select "textarea#b_proc_pbody", :name => "b_proc[pbody]"
      assert_select "input#b_proc_pcode", :name => "b_proc[pcode]"
    end
  end
end
