RSpec.describe DocumentDirectivesController, type: :controller do
  
  let(:valid_attributes) { { directive_id: 1, document_id: 1 } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user

    #document = FactoryGirl.create(:document)
    #directive = FactoryGirl.create(:directive)
  end

  describe "GET index" do
    it "assigns all document_directives as @document_directives" do
      document_directive = DocumentDirective.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('document_directives/index')
    end
    it "loads all of the document_directives into @document_directives" do
      dd1 = FactoryGirl.create(:document_directive)
      dd2 = FactoryGirl.create(:document_directive)
      get :index, {}, valid_session
      expect(assigns(:document_directives)).to match_array([dd1, dd2])
    end
  end

  describe "GET show" do
    it "assigns the requested document_directive as @document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      get :show, {:id => document_directive.to_param}, valid_session
      expect(assigns(:document_directive)).to eq(document_directive)
    end
  end

  describe "GET new" do
    it "assigns a new document_directive as @document_directive" do
      get :new, {}, valid_session
      expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
    end
  end

  describe "GET edit" do
    it "assigns the requested document_directive as @document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      get :edit, {:id => document_directive.to_param}, valid_session
      expect(assigns(:document_directive)).to eq(document_directive)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DocumentDirective" do
        expect {
          post :create, {:document_directive => valid_attributes}, valid_session
        }.to change(DocumentDirective, :count).by(1)
      end

      it "assigns a newly created document_directive as @document_directive" do
        post :create, {:document_directive => valid_attributes}, valid_session
        expect(assigns(:document_directive)).to be_a(DocumentDirective)
        expect(assigns(:document_directive)).to be_persisted
      end

      it "redirects to the created document_directive" do
        post :create, {:document_directive => valid_attributes}, valid_session
       expect(response).to redirect_to(DocumentDirective.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document_directive as @document_directive" do
        expect_any_instance_of(DocumentDirective).to receive(:save).and_return(false)
        post :create, {:document_directive => {}}, valid_session
        expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(DocumentDirective).to receive(:save).and_return(false)
        #DocumentDirective.any_instance.stub(:save).and_return(false)
        post :create, {:document_directive => {}}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        expect_any_instance_of(DocumentDirective).to receive(:save).and_return(false)
        #DocumentDirective.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => document_directive.to_param, :document_directive => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested document_directive as @document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        put :update, {:id => document_directive.to_param, :document_directive => valid_attributes}, valid_session
        expect(assigns(:document_directive)).to eq(document_directive)
      end

      it "redirects to the document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        put :update, {:id => document_directive.to_param, :document_directive => valid_attributes}, valid_session
        expect(response).to redirect_to(document_directive)
      end
    end

    describe "with invalid params" do
      it "assigns the document_directive as @document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        expect_any_instance_of(DocumentDirective).to receive(:save).and_return(false)
        #DocumentDirective.any_instance.stub(:save).and_return(false)
        put :update, {:id => document_directive.to_param, :document_directive => {}}, valid_session
        expect(assigns(:document_directive)).to eq(document_directive)
      end

      it "re-renders the 'edit' template" do
        document_directive = DocumentDirective.create! valid_attributes
        expect_any_instance_of(DocumentDirective).to receive(:save).and_return(false)
        #DocumentDirective.any_instance.stub(:save).and_return(false)
        put :update, {:id => document_directive.to_param, :document_directive => {}}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      expect {
        delete :destroy, {:id => document_directive.to_param}, valid_session
      }.to change(DocumentDirective, :count).by(-1)
    end

    it "redirects to the document_directives list" do
      document_directive = DocumentDirective.create! valid_attributes
      delete :destroy, {:id => document_directive.to_param}, valid_session
      expect(response).to redirect_to(document_url)
    end
  end

end
