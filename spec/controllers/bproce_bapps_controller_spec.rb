RSpec.describe BproceBappsController, type: :controller do

  def valid_attributes
    { bproce_id: 1,
      bapp_id: 1,
      apurpose: 'purpose in process'
    }
  end
  def valid_session
    {}
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)

    bproce = create(:bproce)
    bapp = create(:bapp)
  end

  describe "GET show" do
    it "assigns the requested bproce_bapp as @bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :show, {:id => bproce_bapp.to_param}, valid_session
      expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
    end
  end

  describe "GET edit" do
    it "assigns the requested bproce_bapp as @bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :edit, {:id => bproce_bapp.to_param}, valid_session
      expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceBapp" do
        expect {
          post :create, {:bproce_bapp => valid_attributes}, valid_session
        }.to change(BproceBapp, :count).by(1)
      end

      it "assigns a newly created bproce_bapp as @bproce_bapp" do
        post :create, {:bproce_bapp => valid_attributes}, valid_session
        expect(assigns(:bproce_bapp)).to be_a(BproceBapp)
        expect(assigns(:bproce_bapp)).to be_persisted
      end

      it "redirects to the created bproce_bapp" do
        post :create, {:bproce_bapp => valid_attributes}, valid_session
        expect(response).to redirect_to(BproceBapp.last.bapp)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_bapp as @bproce_bapp" do
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        post :create, {:bproce_bapp => {  }}, valid_session
        expect(assigns(:bproce_bapp)).to be_a_new(BproceBapp)
      end

    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => { "these" => "params" }}, valid_session
      end

      it "assigns the requested bproce_bapp as @bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => valid_attributes}, valid_session
        expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
      end

      it "redirects to the bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => valid_attributes}, valid_session
        expect(response).to redirect_to(bproce_bapp)
      end
    end

    describe "with invalid params" do
      it "assigns the bproce_bapp as @bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => {  }}, valid_session
        expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
      end

      it "re-renders the 'edit' template" do
        bproce_bapp = BproceBapp.create! valid_attributes
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => {  }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      bproce = create(:bproce)
      bapp = create(:bapp)
      bproce_bapp.bproce_id = bproce.id
      bproce_bapp.bapp_id = bapp.id
      expect {
        delete :destroy, {:id => bproce_bapp.to_param, :bproce_id => bproce.to_param}, valid_session
      }.to change(BproceBapp, :count).by(-1)
    end

    it "redirects to the bproce_bapps list" do
      bproce_bapp = BproceBapp.create! valid_attributes
      delete :destroy, {:id => bproce_bapp.to_param}, valid_session
      expect(response).to redirect_to bapp_url
    end
  end

end
