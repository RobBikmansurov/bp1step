require 'spec_helper'

describe "metrics/edit" do
  before(:each) do
    @metric = assign(:metric, stub_model(Metric,
      :bproce => nil,
      :name => "MyString",
      :shortname => "MyString",
      :description => "MyText",
      :note => "MyText",
      :depth => 1
    ))
  end

  it "renders the edit metric form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", metric_path(@metric), "post" do
      assert_select "input#metric_bproce[name=?]", "metric[bproce]"
      assert_select "input#metric_name[name=?]", "metric[name]"
      assert_select "input#metric_shortname[name=?]", "metric[shortname]"
      assert_select "textarea#metric_description[name=?]", "metric[description]"
      assert_select "textarea#metric_note[name=?]", "metric[note]"
      assert_select "input#metric_depth[name=?]", "metric[depth]"
    end
  end
end
