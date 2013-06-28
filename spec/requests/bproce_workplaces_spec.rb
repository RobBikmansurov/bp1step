require 'spec_helper'

describe "BproceWorkplaces" do
  before(:each) do
    @bproce = create(:bproce)
  end
  describe "GET /bproce_workplaces" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bproce_workplace_path(@bproce)
      response.status.should be(200)
    end
  end
end
