require 'rails_helper'

RSpec.describe "letters/show", :type => :view do
  before(:each) do
    @letter = assign(:letter, Letter.create!(
      :regnumber => "Regnumber",
      :number => "Number",
      :subject => "Subject",
      :source => "Source",
      :sender => "MyText",
      :body => "MyText",
      :status => 1,
      :result => "MyText",
      :letter => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Regnumber/)
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
