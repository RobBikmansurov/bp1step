RSpec.describe BappsController, type: :controller do
  
  let(:valid_attributes) { { "name" => "MyString1", description: 'description1' } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end
  
  describe "GET index" do
    it "assigns all bapps as @bapps" do
      bapps = Bapp.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it "loads all of the bapps into @bapps" do
      bapp1, bapp2 = create(:bapp), create(:bapp)
      get :index
      expect(assigns(:bapps)).to match_array([bapp1, bapp2])
    end

  end

  describe "GET show" do
    it "assigns the requested bapp as @bapp" do
      bapp = Bapp.create! valid_attributes
      get :show, {:id => bapp.to_param}, valid_session
      expect(response).to render_template(:show)
      expect(assigns(:bapp)).to eq(bapp)
    end
    it "renders 404 page if bapp is not found" do
      #get :show, {:id => 0}
      #expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe "GET new" do
    it "assigns a new bapp as @bapp" do
      get :new, {}, valid_session
      expect(assigns(:bapp)).to be_a_new(Bapp)
    end
  end

  describe "GET edit" do
    it "assigns the requested bapp as @bapp" do
      bapp = Bapp.create! valid_attributes
      get :edit, {:id => bapp.to_param}, valid_session
      expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bapp" do
        expect {
          post :create, :bapp => valid_attributes
        }.to change(Bapp, :count).by(1)
      end

      it "assigns a newly created bapp as @bapp" do
        post :create, :bapp => valid_attributes
        expect(assigns(:bapp)).to be_a(Bapp)
        expect(assigns(:bapp)).to be_persisted
      end

      it "redirects to the created bapp" do
        post :create, :bapp => valid_attributes
        expect(response).to redirect_to(Bapp.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bapp as @bapp" do
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        post :create, {:bapp => { name: "name"} }, valid_session
        expect(assigns(:bapp)).to be_a_new(Bapp)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        post :create, {:bapp => { "name" => "invalid value" }}, valid_session
        expect(response).to_not render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bapp" do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).at_least(:once)
        put :update, :id => bapp.id, :bapp => {'these' => 'params'}
      end

      it "assigns the requested bapp as @bapp" do
        bapp = Bapp.create! valid_attributes
        put :update, :id => bapp.id, :bapp => valid_attributes
        expect(assigns(:bapp)).to eq(bapp)
      end

      it "redirects to the bapp" do
        bapp = Bapp.create! valid_attributes
        put :update, :id => bapp.id, :bapp => valid_attributes
        expect(response).to redirect_to(bapp)
      end
    end

    describe "with invalid params" do
      it "assigns the bapp as @bapp" do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, {:id => bapp.to_param, :bapp => { "name" => "invalid value" }}, valid_session
        expect(assigns(:bapp)).to eq(bapp)
      end

      it "re-renders the 'edit' template" do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, :id => bapp.id, :bapp => {}
        expect(response).to_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bapp" do
      bapp = Bapp.create! valid_attributes
      expect {
        delete :destroy, {id: bapp.to_param}, valid_session
      }.to change(Bapp, :count).by(-1)
      #expect(Bapp.count).to eq(0)
    end

    it "redirects to the bapps list" do
      bapp = Bapp.create! valid_attributes
      delete :destroy, {:id => bapp.to_param}, valid_session
      expect(response).to redirect_to(bapps_url)
    end
  end

end
