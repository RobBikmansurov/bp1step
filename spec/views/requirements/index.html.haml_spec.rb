require 'rails_helper'

RSpec.describe "requirements/index", :type => :view do
  before(:each) do
    assign(:requirements, [
      Requirement.create!(
        :label => "Label",
        :source => "Source",
        :body => "MyText",
        :status => "Status",
        :result => "MyText",
        :letter => nil,
        :user => nil
      ),
      Requirement.create!(
        :label => "Label",
        :source => "Source",
        :body => "MyText",
        :status => "Status",
        :result => "MyText",
        :letter => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of requirements" do
    render
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
