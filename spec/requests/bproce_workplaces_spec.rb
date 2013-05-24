require 'spec_helper'

describe "BproceWorkplaces" do
  describe "GET /bproce_workplaces" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bproce_workplaces_path
      response.status.should be(200)
    end
  end
end
