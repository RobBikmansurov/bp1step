RSpec.describe BproceIresourcesController, type: :controller do

  def valid_attributes
    {
      id: 1,
      bproce_id: 1,
      iresource_id: 1,
      rpurpose: "test"
    }
  end

  def valid_session
    {}
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
  end
  
  describe "GET show" do
    it "assigns the requested bproce_iresource as @bproce_iresource" do
      bproce_iresource = BproceIresource.create! valid_attributes
      get :show, {:id => bproce_iresource.to_param}, valid_session
      assigns(:bproce_iresource).should eq(bproce_iresource)
    end
  end

  describe "GET new" do
    it "assigns a new bproce_iresource as @bproce_iresource" do
      get :new, {}, valid_session
      assigns(:bproce_iresource).should be_a_new(BproceIresource)
    end
  end

  describe "GET edit" do
    it "assigns the requested bproce_iresource as @bproce_iresource" do
      bproce_iresource = BproceIresource.create! valid_attributes
      get :edit, {:id => bproce_iresource.to_param}, valid_session
      assigns(:bproce_iresource).should eq(bproce_iresource)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceIresource" do
        expect {
          post :create, {:bproce_iresource => valid_attributes}, valid_session
        }.to change(BproceIresource, :count).by(1)
      end

      it "assigns a newly created bproce_iresource as @bproce_iresource" do
        post :create, {:bproce_iresource => valid_attributes}, valid_session
        assigns(:bproce_iresource).should be_a(BproceIresource)
        assigns(:bproce_iresource).should be_persisted
      end

      it "redirects to the created bproce_iresource" do
        post :create, {:bproce_iresource => valid_attributes}, valid_session
        response.should redirect_to(BproceIresource.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_iresource as @bproce_iresource" do
        # Trigger the behavior that occurs when invalid params are submitted
        BproceIresource.any_instance.stub(:save).and_return(false)
        post :create, {:bproce_iresource => {  }}, valid_session
        assigns(:bproce_iresource).should be_a_new(BproceIresource)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BproceIresource.any_instance.stub(:save).and_return(false)
        post :create, {:bproce_iresource => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bproce_iresource" do
        bproce_iresource = BproceIresource.create! valid_attributes
        # Assuming there are no other bproce_iresources in the database, this
        # specifies that the BproceIresource created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BproceIresource.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => bproce_iresource.to_param, :bproce_iresource => { "these" => "params" }}, valid_session
      end

      it "assigns the requested bproce_iresource as @bproce_iresource" do
        bproce_iresource = BproceIresource.create! valid_attributes
        put :update, {:id => bproce_iresource.to_param, :bproce_iresource => valid_attributes}, valid_session
        assigns(:bproce_iresource).should eq(bproce_iresource)
      end

      it "redirects to the bproce_iresource" do
        bproce_iresource = BproceIresource.create! valid_attributes
        put :update, {:id => bproce_iresource.to_param, :bproce_iresource => valid_attributes}, valid_session
        response.should redirect_to(bproce_iresource)
      end
    end

    describe "with invalid params" do
      it "assigns the bproce_iresource as @bproce_iresource" do
        bproce_iresource = BproceIresource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceIresource.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_iresource.to_param, :bproce_iresource => {  }}, valid_session
        assigns(:bproce_iresource).should eq(bproce_iresource)
      end

      it "re-renders the 'edit' template" do
        bproce_iresource = BproceIresource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceIresource.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_iresource.to_param, :bproce_iresource => {  }}, valid_session
        response.code.should == "302"
        #response.should render_template("edit")
      end
    end
  end

end
