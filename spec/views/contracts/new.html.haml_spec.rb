require 'spec_helper'

describe "contracts/new" do
  before(:each) do
    assign(:contract, stub_model(Contract,
      :owner_id => nil,
      :number => "MyString",
      :name => "MyString",
      :status => "MyString",
      :description => "MyText",
      :text => "MyText",
      :note => "MyText"
    ).as_new_record)
  end

  it "renders new contract form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contracts_path, "post" do
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
