require 'spec_helper'

describe "BproceIresources" do
  before(:each) do
    @bproce_iresource = create(:bproce_iresource)
  end
  describe "GET /bproce_iresources" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bproce_iresource_path(@bproce_iresource)
      response.status.should be(200)
    end
  end
end
