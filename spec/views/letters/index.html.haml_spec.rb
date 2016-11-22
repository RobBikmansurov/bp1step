require 'spec_helper'

RSpec.describe "letters/index", :type => :view do
  before(:each) do
    assign(:letters, [
      Letter.create!(
        :regnumber => "Regnumber",
        date: "2015-01-01",
        :number => "Number",
        :subject => "Subject",
        :source => "Source",
        :sender => "MyText",
        :body => "MyText",
        :status => 1,
        :result => "MyText",
        :letter => nil
      ),
      Letter.create!(
        :regnumber => "Regnumber",
        date: "2015-01-01",
        :number => "Number",
        :subject => "Subject",
        :source => "Source",
        :sender => "MyText",
        :body => "MyText",
        :status => 1,
        :result => "MyText",
        :letter => nil
      )
    ])
  end

  it "renders a list of letters" do
    render 
    assert_select "tr>td", :text => "Regnumber".to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
