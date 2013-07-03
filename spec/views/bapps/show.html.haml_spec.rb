require 'spec_helper'

include Devise::TestHelpers

describe "bapps/show.html.haml" do
  before(:each) do
    @bapp = assign(:bapp, stub_model(Bapp,
      :name => "Name",
      :type => "Type",
      :description => "Description",
      created_at: DateTime.now,
      updated_at: DateTime.now
    ))
  end

  it "renders attributes in <p>" do
    assign(:user, stub_model(User))
    sort_column = 'name'
    render
    rendered.should match(/Name/)
    rendered.should match(/Type/)
    rendered.should match(/Description/)
  end
end
