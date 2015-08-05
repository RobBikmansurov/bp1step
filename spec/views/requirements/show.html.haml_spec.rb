require 'rails_helper'

RSpec.describe "requirements/show", :type => :view do
  before(:each) do
    @requirement = assign(:requirement, Requirement.create!(
      :label => "Label",
      :source => "Source",
      :body => "MyText",
      :status => "Status",
      :result => "MyText",
      :letter => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
