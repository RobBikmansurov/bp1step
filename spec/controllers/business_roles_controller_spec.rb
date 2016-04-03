RSpec.describe BusinessRolesController, type: :controller do
  render_views
  let(:valid_attributes) { { id: 1, name: "MyString1", description: 'description1', bproce_id: 1 } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user

    allow(controller).to receive(:authenticate_user!).and_return(true)
  end
  
  describe "GET index" do
    it "assigns all business_roles as @business_roles" do
      business_role = BusinessRole.create
      get :index
      expect(assigns(:business_roles)).to render_template("index")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the business_roles into @business_roles" do
      business_role1, business_role2 = create(:business_role), create(:business_role)
      get :index
      expect(assigns(:business_roles)).to match_array([business_role1, business_role2])
    end

  end

  describe "GET show" do
    it "assigns the requested business_role as @business_role" do
      business_role = BusinessRole.create! valid_attributes
      get :show, {:id => business_role.to_param}, valid_session
      response.should render_template(:show)
      assigns(:business_role).should eq(business_role)
    end
    it "renders 404 page if business_role is not found" do
      #get :show, {:id => 0}
      #assigns(:business_role).should eq(business_role)
    end
  end

  describe "GET new" do
    it "assigns a new business_role as @business_role" do
      get :new, {}, valid_session
      assigns(:business_role).should be_a_new(BusinessRole)
    end
  end

  describe "GET edit" do
    it "assigns the requested business_role as @business_role" do
      business_role = BusinessRole.create! valid_attributes
      get :edit, {:id => business_role.to_param}, valid_session
      assigns(:business_role).should eq(business_role)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BusinessRole" do
        expect {
          post :create, :business_role => valid_attributes
        }.to change(BusinessRole, :count).by(1)
      end

      it "assigns a newly created business_role as @business_role" do
        post :create, :business_role => valid_attributes
        assigns(:business_role).should be_a(BusinessRole)
        assigns(:business_role).should be_persisted
      end

      it "redirects to the created business_role" do
        post :create, :business_role => valid_attributes
        response.should redirect_to(BusinessRole.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved business_role as @business_role" do
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        post :create, :business_role => {}
        assigns(:business_role).should be_a_new(BusinessRole)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        post :create, :business_role => {}
        response.should_not render_template("business_roles/new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested business_role" do
        business_role = BusinessRole.create! valid_attributes
        BusinessRole.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => business_role.id, :business_role => {'these' => 'params'}
      end

      it "assigns the requested business_role as @business_role" do
        business_role = BusinessRole.create! valid_attributes
        put :update, :id => business_role.id, :business_role => valid_attributes
        assigns(:business_role).should eq(business_role)
      end

      it "redirects to the business_role" do
        business_role = BusinessRole.create! valid_attributes
        put :update, :id => business_role.id, :business_role => valid_attributes
        response.should redirect_to(business_role)
      end
    end

    describe "with invalid params" do
      it "assigns the business_role as @business_role" do
        business_role = BusinessRole.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        put :update, :id => business_role.id, :business_role => {}
        assigns(:business_role).should eq(business_role)
      end

      it "re-renders the 'edit' template" do
        business_role = BusinessRole.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        put :update, :id => business_role.id, :business_role => {}
        response.should_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested business_role" do
      business_role = BusinessRole.create! valid_attributes
      expect {
        delete :destroy, {id: business_role.to_param}, valid_session
      }.to change(BusinessRole, :count).by(-1)
      #expect(BusinessRole.count).to eq(0)
    end

    it "redirects to the business_roles list" do
      business_role = BusinessRole.create! valid_attributes
      delete :destroy, {:id => business_role.to_param}, valid_session
      response.should redirect_to(business_roles_url)
    end
  end

end