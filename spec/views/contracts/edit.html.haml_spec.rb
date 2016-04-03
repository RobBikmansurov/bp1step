require 'spec_helper'

describe "contracts/edit" do
  before(:each) do
    @contract = assign(:contract, stub_model(Contract,
      :owner_id => nil,
      :number => "MyString",
      :name => "MyString",
      :status => "MyString",
      :description => "MyText",
      :text => "MyText",
      :note => "MyText"
    ))
  end

  it "renders the edit contract form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contract_path(@contract), "post" do
      assert_select "input#contract_owner_id[name=?]", "contract[owner_id]"
      assert_select "input#contract_number[name=?]", "contract[number]"
      assert_select "input#contract_name[name=?]", "contract[name]"
      assert_select "input#contract_status[name=?]", "contract[status]"
      assert_select "textarea#contract_description[name=?]", "contract[description]"
      assert_select "textarea#contract_text[name=?]", "contract[text]"
      assert_select "textarea#contract_note[name=?]", "contract[note]"
    end
  end
end
