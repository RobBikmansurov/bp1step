RSpec.describe WorkplacesController, :type => :controller do

  let(:valid_attributes) { {name: "workplace", description: 'workplace description', designation: "workplace designation" } }
  let(:valid_session) { { } }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET index" do
    it "assigns all workplaces as @workplaces" do
      workplace = FactoryGirl.create(:workplace)
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('workplaces/index')
    end

    it "loads all of the workplaces into @workplaces" do
      workplace1 = FactoryGirl.create(:workplace)
      workplace2 = FactoryGirl.create(:workplace)
      get :index
      expect(assigns(:workplaces)).to match_array([workplace1, workplace2])
    end
  end

  describe "GET show" do
    it "assigns the requested workplace as @workplace" do
      workplace = FactoryGirl.create(:workplace)
      get :show, :id => workplace.id
      expect(assigns(:workplace)).to eq(workplace)
    end
  end

  describe "GET new" do
    it "assigns a new workplace as @workplace" do
      get :new
      expect(assigns(:workplace)).to be_a_new(Workplace)
    end
  end

  describe "GET edit" do
    it "assigns the requested workplace as @workplace" do
      workplace = FactoryGirl.create(:workplace)
      get :edit, :id => workplace.id
      expect(assigns(:workplace)).to eq(workplace)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Workplace" do
        expect {
          post :create, {:workplace => valid_attributes}, valid_session
        }.to change(Workplace, :count).by(1)
      end

      it "assigns a newly created workplace as @workplace" do
        post :create, {:workplace => valid_attributes}, valid_session
        expect(assigns(:workplace)).to be_a(Workplace)
        expect(assigns(:workplace)).to be_persisted
      end

      it "redirects to the created workplace" do
        post :create, { :workplace => valid_attributes }, valid_session
        expect(response).to redirect_to(Workplace.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved workplace as @workplace" do
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        post :create, { :workplace => { name: 'invalid name'} }, valid_session
        expect(assigns(:workplace)).to be_a_new(Workplace)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        post :create, {:workplace => {} }, valid_session
        expect(response).to_not render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested workplace" do
        workplace = FactoryGirl.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).at_least(:once)
        put :update, {:id => workplace.to_param, :workplace => { "name" => "test_name" }}, valid_session
      end

      it "assigns the requested workplace as @workplace" do
        workplace = FactoryGirl.create(:workplace)
        put :update, :id => workplace.id, :workplace => valid_attributes
        expect(assigns(:workplace)).to eq(workplace)
      end

      it "redirects to the workplace" do
        workplace = FactoryGirl.create(:workplace)
        put :update, :id => workplace.id, :workplace => valid_attributes
        expect(response).to redirect_to(workplace)
      end
    end

    describe "with invalid params" do
      it "assigns the workplace as @workplace" do
        workplace = FactoryGirl.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        put :update, {:id => workplace.to_param, :agent => { "name" => "invalid value" }}, valid_session
        expect(assigns(:workplace)).to eq(workplace)
      end

      it "re-renders the 'edit' template" do
        workplace = FactoryGirl.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        put :update, {:id => workplace.to_param, :workplace => { "name" => "invalid value" }}, valid_session
        expect(response).to_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested workplace" do
      workplace = FactoryGirl.create(:workplace)
      expect {
        delete :destroy, :id => workplace.id
      }.to change(Workplace, :count).by(-1)
    end

    it "redirects to the workplaces list" do
      workplace = FactoryGirl.create(:workplace)
      delete :destroy, :id => workplace.id
      expect(response).to redirect_to(workplaces_url)
    end
  end

end
