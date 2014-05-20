require 'spec_helper'

describe "agents/edit" do
  before(:each) do
    @agent = assign(:agent, stub_model(Agent,
      :name => "MyString",
      :town => "MyString",
      :address => "MyString",
      :contacts => "MyText"
    ))
  end

  it "renders the edit agent form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", agent_path(@agent), "post" do
      assert_select "input#agent_name[name=?]", "agent[name]"
      assert_select "input#agent_town[name=?]", "agent[town]"
      assert_select "input#agent_address[name=?]", "agent[address]"
      assert_select "textarea#agent_contacts[name=?]", "agent[contacts]"
    end
  end
end
