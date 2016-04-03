require 'spec_helper'


describe "BproceBapps" do
  before(:each) do
    @bp = create(:bproce)
  end
  describe "GET /bproces/1/bapps" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bproce_path(@bp) + '/bapps'
      response.status.should be(200)
    end
  end
end
