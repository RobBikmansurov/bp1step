RSpec.describe BprocesController, type: :controller do
  def valid_attributes
    {
      :id => 1,
      :shortname => "test_short",
      :name => "test_name10",
      :fullname => "test_fullname"
    }
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET index" do
    it "assigns all bproces as @bproces" do
      bproce = Bproce.create! valid_attributes
      get :index
      expect(assigns(:bproces)).to eq([bproce])
    end
  end

  describe "GET show" do
    it "assigns the requested bproce as @bproce" do
      bproce = Bproce.create! valid_attributes
      get :show, :id => bproce.id
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe "GET new" do
    it "assigns a new bproce as @bproce" do
      get :new
      expect(assigns(:bproce)).to be_a_new(Bproce)
    end
  end

  describe "GET edit" do
    it "assigns the requested bproce as @bproce" do
      bproce = Bproce.create! valid_attributes
      get :edit, :id => bproce.id
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bproce" do
        expect {
          post :create, :bproce => valid_attributes
        }.to change(Bproce, :count).by(1)
      end

      it "assigns a newly created bproce as @bproce" do
        post :create, :bproce => valid_attributes
        expect(assigns(:bproce)).to be_a(Bproce)
        expect(assigns(:bproce)).to be_persisted
      end

      it "redirects to the created bproce" do
        post :create, :bproce => valid_attributes
        expect(response).to redirect_to(Bproce.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce as @bproce" do
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        post :create, :bproce => {}
        expect(assigns(:bproce)).to be_a_new(Bproce)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        post :create, :bproce => {}
        expect(response).to_not render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bproce" do
        bproce = Bproce.create! valid_attributes
        #Bproce.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, :id => bproce.id, :bproce => {'these' => 'params'}
      end

      it "assigns the requested bproce as @bproce" do
        bproce = Bproce.create! valid_attributes
        put :update, :id => bproce.id, :bproce => valid_attributes
        expect(assigns(:bproce)).to eq(bproce)
      end

      it "redirects to the bproce" do
        bproce = Bproce.create! valid_attributes
        put :update, :id => bproce.id, :bproce => valid_attributes
        expect(response).to redirect_to(bproce)
      end
    end

    describe "with invalid params" do
      it "assigns the bproce as @bproce" do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, :id => bproce.id, :bproce => {}
        expect(assigns(:bproce)).to eq(bproce)
      end

      it "re-renders the 'edit' template" do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, :id => bproce.id, :bproce => {}
        expect(response).to_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce" do
      bproce = Bproce.create! valid_attributes
      expect {
        delete :destroy, :id => bproce.id
      }.to change(Bproce, :count).by(-1)
    end

    it "redirects to the bproces list" do
      bproce = Bproce.create! valid_attributes
      delete :destroy, :id => bproce.id
      expect(response).to redirect_to(bproces_url)
    end
  end

end
