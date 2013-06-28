require 'spec_helper'

describe BproceDocumentsController do
  def valid_attributes
    {
      bproce_id: 1,
      id: 1,
      place: 'place',
      part: 1,
      owner_id: 1,
      dlevel: 1,
      name: 'test_document'
    }
  end
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested documents as @documents" do
      document = Document.create! valid_attributes
      bproce = create(:bproce)
      get :show, {:id => document.to_param}, valid_session
      assigns(:bproce_document).should eq(document)
    end
  end


end
