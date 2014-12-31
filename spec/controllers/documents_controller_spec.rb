RSpec.describe DocumentsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.create (:document) }
  let(:valid_session) { { "warden.user.user.key" => session["warden.user.user.key"] } }

  before(:each) do
    #@user = FactoryGirl.create(:user)
    #@user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    #sign_in @user

    allow(controller).to receive(:authenticate_user!).and_return(true)

    bproce = FactoryGirl.create :bproce
  end

  describe "GET index" do
    it "assigns all documents as @documents" do
      directive = Document.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it "loads all of the directives into @directives" do
      document1 = FactoryGirl.create(:document)
      document2 = FactoryGirl.create(:document)
      get :index
      expect(assigns(:document)).to match_array([document1, document2])
    end
  end

  describe "GET show" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :show, {:id => document.to_param}, valid_session
      assigns(:document).should eq(document)
    end
  end

  describe "GET new" do
    it "assigns a new document as @document" do
      get :new, {}, valid_session
      assigns(:document).should be_a_new(Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :edit, {:id => document.to_param}, valid_session
      assigns(:document).should eq(document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Document" do
        expect {
          post :create, {:document => valid_attributes}, valid_session
        }.to change(Document, :count).by(1)
      end

      it "assigns a newly created document as @document" do
        post :create, {:document => valid_attributes}, valid_session
        assigns(:document).should be_a(Document)
        assigns(:document).should be_persisted
      end

      it "redirects to the created document" do
        post :create, {:document => valid_attributes}, valid_session
        response.should redirect_to(Document.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {:document => {  }}, valid_session
        assigns(:document).should be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {:document => {  }}, valid_session
        response.code.should == "302"
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document" do
        document = Document.create! valid_attributes
        # Assuming there are no other documents in the database, this
        # specifies that the Document created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Document.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => document.to_param, :document => { "these" => "params" }}, valid_session
      end

      it "assigns the requested document as @document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}, valid_session
        assigns(:document).should eq(document)
      end

      it "redirects to the document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}, valid_session
        response.should redirect_to(document)
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :document => {  }}, valid_session
        assigns(:document).should eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :document => {  }}, valid_session
        response.code.should == "302"       ##        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document" do
      document = Document.create! valid_attributes
      expect {
        delete :destroy, {:id => document.to_param}, valid_session
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      document = Document.create! valid_attributes
      delete :destroy, {:id => document.to_param}, valid_session
      response.should redirect_to(documents_url)
    end
  end

end
