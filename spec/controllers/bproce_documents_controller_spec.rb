require 'spec_helper'

describe BproceDocumentsController do
  describe "GET show" do
    it "assigns the requested documents as @documents" do
      bproce = FactoryGirl.create(:bproce)
      document = FactoryGirl.create(:document)
      document.bproce_id = bproce.id
      document.save
      get :show, {:id => bproce.to_param}
      expect(assigns(:documents)).to eq([document])
    end
  end


end
