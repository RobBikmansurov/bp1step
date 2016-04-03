require 'spec_helper'

describe "documents/show" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :name => "Name",
      :filename => "Filename",
      :description => "Description",
      :status => "Status",
      :part => "Part",
      :place => "Place",
      created_at: DateTime.now,
      updated_at: DateTime.now
    ))
    @user = build(:user)
    sign_in @user
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Filename/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Part/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Place/)
  end
end
