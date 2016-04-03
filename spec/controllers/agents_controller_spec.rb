RSpec.describe AgentsController, :type => :controller do

  let(:valid_attributes) { { "name" => "Agent name" } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET index" do
    it "assigns all agents as @agents" do
      agent = Agent.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('agents/index')
    end

    it "loads all of the agents into @agents" do
      agent1 = Agent.create! valid_attributes
      agent2 = Agent.create! valid_attributes
      get :index

      expect(assigns(:agents)).to match_array([agent1, agent2])
    end
  end

  describe "GET show" do
    it "assigns the requested agent as @agent" do
      agent = Agent.create! valid_attributes
      get :show, {:id => agent.to_param}, valid_session
      expect(assigns(:agent)).to eq(agent)
    end
  end

  describe "GET new" do
    it "assigns a new agent as @agent" do
      get :new, {}, valid_session
      expect(assigns(:agent)).to be_a_new(Agent)
    end
  end

  describe "GET edit" do
    it "assigns the requested agent as @agent" do
      agent = Agent.create! valid_attributes
      get :edit, {:id => agent.to_param}, valid_session
      expect(assigns(:agent)).to eq(agent)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Agent" do
        expect {
          post :create, {:agent => valid_attributes}, valid_session
        }.to change(Agent, :count).by(1)
      end

      it "assigns a newly created agent as @agent" do
        post :create, {:agent => valid_attributes}, valid_session
        expect(assigns(:agent)).to be_a(Agent)
        expect(assigns(:agent)).to be_persisted
      end

      it "redirects to the created agent" do
        post :create, {:agent => valid_attributes}, valid_session
        expect(response).to redirect_to(Agent.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved agent as @agent" do
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        post :create, {:agent => { "name" => "invalid value" }}, valid_session
        expect(assigns(:agent)).to be_a_new(Agent)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        post :create, {:agent => { "name" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested agent" do
        agent = Agent.create! valid_attributes
        expect_any_instance_of(Agent).to receive(:save).at_least(:once)
        put :update, {:id => agent.to_param, :agent => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested agent as @agent" do
        agent = Agent.create! valid_attributes
        put :update, {:id => agent.to_param, :agent => valid_attributes}, valid_session
        expect(assigns(:agent)).to eq(agent)
      end

      it "redirects to the agent" do
        agent = Agent.create! valid_attributes
        put :update, {:id => agent.to_param, :agent => valid_attributes}, valid_session
        expect(response).to redirect_to(agent)
      end
    end

    describe "with invalid params" do
      it "assigns the agent as @agent" do
        agent = Agent.create! valid_attributes
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        put :update, {:id => agent.to_param, :agent => { "name" => "invalid value" }}, valid_session
        expect(assigns(:agent)).to eq(agent)
      end

      it "re-renders the 'edit' template" do
        agent = Agent.create! valid_attributes
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        put :update, {:id => agent.to_param, :agent => { "name" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested agent" do
      agent = Agent.create! valid_attributes
      expect {
        delete :destroy, {:id => agent.to_param}, valid_session
      }.to change(Agent, :count).by(-1)
    end

    it "redirects to the agents list" do
      agent = Agent.create! valid_attributes
      delete :destroy, {:id => agent.to_param}, valid_session
      expect(response).to redirect_to(agents_url)
    end
  end

end
