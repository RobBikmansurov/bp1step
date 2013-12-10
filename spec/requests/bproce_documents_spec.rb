require 'spec_helper'

describe "BproceDocuments" do
  before(:each) do
    @bp = create(:bproce)
    @bpd = create(:bproce_document)
  end

  describe "GET /bproce_document/1" do
    it "works! (now write some real specs)" do
      get bproce_document_path(@bpd)
      response.status.should be(200)
    end
  end
end
