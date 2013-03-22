require 'spec_helper'

describe "iresources/edit" do
  before(:each) do
    @iresource = assign(:iresource, stub_model(Iresource,
      :level => "MyString",
      :label => "MyString",
      :location => "MyString",
      :volume => 1,
      :note => "MyText",
      :access_read => "MyString",
      :access_write => "MyString",
      :access_other => "MyString",
      :users => nil
    ))
  end

  it "renders the edit iresource form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", iresource_path(@iresource), "post" do
      assert_select "input#iresource_level[name=?]", "iresource[level]"
      assert_select "input#iresource_label[name=?]", "iresource[label]"
      assert_select "input#iresource_location[name=?]", "iresource[location]"
      assert_select "input#iresource_volume[name=?]", "iresource[volume]"
      assert_select "textarea#iresource_note[name=?]", "iresource[note]"
      assert_select "input#iresource_access_read[name=?]", "iresource[access_read]"
      assert_select "input#iresource_access_write[name=?]", "iresource[access_write]"
      assert_select "input#iresource_access_other[name=?]", "iresource[access_other]"
      assert_select "input#iresource_users[name=?]", "iresource[users]"
    end
  end
end
