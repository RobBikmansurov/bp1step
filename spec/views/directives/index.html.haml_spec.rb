require 'spec_helper'

describe "directives/index" do
  before(:each) do
    assign(:directives, [
      stub_model(Directive,
        :title => "Title",
        :number => "Number",
        :name => "Name",
        :note => "Note",
        :body => "Body"
      ),
      stub_model(Directive,
        :title => "Title",
        :number => "Number",
        :name => "Name",
        :note => "Note",
        :body => "Body"
      )
    ])
  end

  it "renders a list of directives" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
    assert_select "tr>td", :text => "Body".to_s, :count => 2
  end
end
