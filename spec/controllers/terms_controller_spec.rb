RSpec.describe TermsController, :type => :controller do

  let(:valid_attributes) { { shortname: "term", name: "term_name", description: "term_description" } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: "admin", description: 'description')
    sign_in @user
  end

  describe "GET index" do
    it "assigns all terms as @terms" do
      term = Term.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('terms/index')
    end
    it "loads all of the terms into @terms" do
      term1 = FactoryGirl.create(:term)
      term2 = FactoryGirl.create(:term)
      get :index
      expect(assigns(:terms)).to match_array([term1, term2])
    end
  end

  describe "GET show" do
    it "assigns the requested term as @term" do
      term = Term.create! valid_attributes
      get :show, {:id => term.to_param}, valid_session
      expect(assigns(:term)).to eq(term)
    end
  end

  describe "GET new" do
    it "assigns a new term as @term" do
      get :new, {}, valid_session
      expect(assigns(:term)).to be_a_new(Term)
    end
  end

  describe "GET edit" do
    it "assigns the requested term as @term" do
      term = Term.create! valid_attributes
      get :edit, {:id => term.to_param}, valid_session
      expect(assigns(:term)).to eq(term)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Term" do
        expect {
          post :create, {:term => valid_attributes}, valid_session
        }.to change(Term, :count).by(1)
      end

      it "assigns a newly created term as @term" do
        post :create, {:term => valid_attributes}, valid_session
        expect(assigns(:term)).to be_a(Term)
        expect(assigns(:term)).to be_persisted
      end

      it "redirects to the created term" do
        post :create, {:term => valid_attributes}, valid_session
        expect(response).to redirect_to(Term.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved term as @term" do
        expect_any_instance_of(Term).to receive(:save).and_return(false)
        post :create, {:term => { "shortname" => "invalid value" }}, valid_session
        expect(assigns(:term)).to be_a_new(Term)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Term).to receive(:save).and_return(false)
        post :create, {:term => { "shortname" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested term" do
        term = Term.create! valid_attributes
        expect_any_instance_of(Term).to receive(:save).and_return(false)
        #Term.any_instance.should_receive(:update_attributes).with({ "shortname" => "MyString" })
        put :update, {:id => term.to_param, :term => { "shortname" => "MyString" }}, valid_session
      end

      it "assigns the requested term as @term" do
        term = Term.create! valid_attributes
        put :update, {:id => term.to_param, :term => valid_attributes}, valid_session
        expect(assigns(:term)).to eq(term)
      end

      it "redirects to the term" do
        term = Term.create! valid_attributes
        put :update, {:id => term.to_param, :term => valid_attributes}, valid_session
        expect(response).to redirect_to(term)
      end
    end

    describe "with invalid params" do
      it "assigns the term as @term" do
        term = Term.create! valid_attributes
        expect_any_instance_of(Term).to receive(:save).and_return(false)
        #Term.any_instance.stub(:save).and_return(false)
        put :update, {:id => term.to_param, :term => { "shortname" => "invalid value" }}, valid_session
        expect(assigns(:term)).to eq(term)
      end

      it "re-renders the 'edit' template" do
        term = Term.create! valid_attributes
        expect_any_instance_of(Term).to receive(:save).and_return(false)
        #Term.any_instance.stub(:save).and_return(false)
        put :update, {:id => term.to_param, :term => { "shortname" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested term" do
      term = Term.create! valid_attributes
      expect {
        delete :destroy, {:id => term.to_param}, valid_session
      }.to change(Term, :count).by(-1)
    end

    it "redirects to the terms list" do
      term = Term.create! valid_attributes
      delete :destroy, {:id => term.to_param}, valid_session
      expect(response).to redirect_to(terms_url)
    end
  end

end
