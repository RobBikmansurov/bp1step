require 'spec_helper'

describe "agents/new" do
  before(:each) do
    assign(:agent, stub_model(Agent,
      :name => "MyString",
      :town => "MyString",
      :address => "MyString",
      :contacts => "MyText"
    ).as_new_record)
  end

  it "renders new agent form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", agents_path, "post" do
      assert_select "input#agent_name[name=?]", "agent[name]"
      assert_select "input#agent_town[name=?]", "agent[town]"
      assert_select "input#agent_address[name=?]", "agent[address]"
      assert_select "textarea#agent_contacts[name=?]", "agent[contacts]"
    end
  end
end
