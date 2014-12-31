RSpec.describe BproceDocumentsController, type: :controller do

  def valid_attributes
    { id: 1,
      bproce_id: 1,
      document_id: 1,
      name: 'document_name',
    }
  end
  def valid_session
    {}
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user

    bproce = create(:bproce)
    bapp = create(:bapp)

  end

  describe "GET show" do
    it "assigns the requested bproce_document as @bproce_document" do
      bproce_document = BproceDocument.create! valid_attributes
      get :show, {:id => bproce_document.to_param}, valid_session
      assigns(:bproce_document).should eq(bproce_document)
    end
  end

  describe "GET edit" do
    it "assigns the requested bproce_document as @bproce_document" do
      bproce_document = BproceDocument.create! valid_attributes
      get :edit, {:id => bproce_document.to_param}, valid_session
      assigns(:bproce_document).should eq(bproce_document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceDocument" do
        expect {
          post :create, {:bproce_document => valid_attributes}, valid_session
        }.to change(BproceDocument, :count).by(1)
      end

      it "assigns a newly created bproce_document as @bproce_document" do
        post :create, {:bproce_document => valid_attributes}, valid_session
        assigns(:bproce_document).should be_a(BproceDocument)
        assigns(:bproce_document).should be_persisted
      end

      it "redirects to the created bproce_document" do
        post :create, {:bproce_document => valid_attributes}, valid_session
        response.should redirect_to(BproceDocument.last.bapp)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_document as @bproce_document" do
        # Trigger the behavior that occurs when invalid params are submitted
        BproceDocument.any_instance.stub(:save).and_return(false)
        post :create, {:bproce_document => {  }}, valid_session
        assigns(:bproce_document).should be_a_new(BproceDocument)
      end

    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bproce_document" do
        bproce_document = BproceDocument.create! valid_attributes
        # Assuming there are no other bproce_documents in the database, this
        # specifies that the BproceDocument created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BproceDocument.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => bproce_document.to_param, :bproce_document => { "these" => "params" }}, valid_session
      end

      it "assigns the requested bproce_document as @bproce_document" do
        bproce_document = BproceDocument.create! valid_attributes
        put :update, {:id => bproce_document.to_param, :bproce_document => valid_attributes}, valid_session
        assigns(:bproce_document).should eq(bproce_document)
      end

      it "redirects to the bproce_document" do
        bproce_document = BproceDocument.create! valid_attributes
        put :update, {:id => bproce_document.to_param, :bproce_document => valid_attributes}, valid_session
        response.should redirect_to(bproce_document)
      end
    end

    describe "with invalid params" do
      it "assigns the bproce_document as @bproce_document" do
        bproce_document = BproceDocument.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceDocument.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_document.to_param, :bproce_document => {  }}, valid_session
        assigns(:bproce_document).should eq(bproce_document)
      end

      it "re-renders the 'edit' template" do
        bproce_document = BproceDocument.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceDocument.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_document.to_param, :bproce_document => {  }}, valid_session
        response.code.should == "302"
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce_document" do
      bproce_document = BproceDocument.create! valid_attributes
      bproce = create(:bproce)
      bapp = create(:bapp)
      bproce_document.bproce_id = bproce.id
      bproce_document.document_id = bapp.document_id
      expect {
        delete :destroy, {:id => bproce_document.to_param, :bproce_id => bproce.to_param}, valid_session
      }.to change(BproceDocument, :count).by(-1)
    end

    it "redirects to the bproce_documents list" do
      bproce_document = BproceDocument.create! valid_attributes
      delete :destroy, {:id => bproce_document.to_param}, valid_session
      response.should redirect_to bapp_url
    end
  end

end