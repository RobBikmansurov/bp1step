require 'spec_helper'

describe "bproces/edit.html.erb" do
  before(:each) do
    @bproce = assign(:bproce, stub_model(Bproce,
      :shortname => "MyString",
      :name => "MyString",
      :fullname => "MyString"
    ))
  end

  it "renders the edit bproce form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bproces_path(@bproce), :method => "post" do
      assert_select "input#bproce_shortname", :name => "bproce[shortname]"
      assert_select "input#bproce_name", :name => "bproce[name]"
      assert_select "input#bproce_fullname", :name => "bproce[fullname]"
    end
  end
end
