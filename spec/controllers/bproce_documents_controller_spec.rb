require 'spec_helper'

describe BproceDocumentsController do
  describe "GET show" do
    it "assigns the requested documents as @documents" do
      bproce = create(:bproce)
      document = create(:document)
      document.bproce_id = bproce
      get :show, {:id => document.to_param}
      expect(assigns(:documents)).to eq([document])
      #assigns(:documents).should eq(document)
    end
  end


end
