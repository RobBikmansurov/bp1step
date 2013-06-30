require 'spec_helper'

describe "workplaces/edit.html.haml" do
  before(:each) do
    @workplace = assign(:workplace, stub_model(Workplace,
      :designation => "MyString",
      :name => "MyString",
      :description => "MyString",
      :typical => false,
      :location => "MyString"
    ))
  end

  it "renders the edit workplace form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => workplaces_path(@workplace), :method => "post" do
      assert_select "input#workplace_designation", :name => "workplace[designation]"
      assert_select "input#workplace_name", :name => "workplace[name]"
      assert_select "input#workplace_description", :name => "workplace[description]"
      assert_select "input#workplace_typical", :name => "workplace[typical]"
      assert_select "input#workplace_location", :name => "workplace[location]"
    end
  end
end
