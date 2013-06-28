require 'spec_helper'

describe "BproceDocuments" do
  before(:each) do
    @bp = create(:bproce)
  end

  describe "GET /bproce_document/1" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bproce_document_path(@bp)
      response.status.should be(200)
    end
  end
end
