# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgentsController, type: :controller do
  let(:agent_attributes) { { name: 'Agent name' } }
  let(:valid_session) { {} }
  let(:agent) { FactoryBot.create(:agent) }
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all agents as @agents' do
      get :index, {}
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('agents/index')
    end

    it 'loads all of the agents into @agents' do
      agent1 = Agent.create! agent_attributes
      agent2 = Agent.create! agent_attributes
      get :index

      expect(assigns(:agents)).to match_array([agent1, agent2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested agent as @agent' do
      get :show, params: { id: agent.id }
      expect(assigns(:agent)).to eq(agent)
    end
  end

  describe 'GET new' do
    it 'assigns a new agent as @agent' do
      get :new, {}
      expect(assigns(:agent)).to be_a_new(Agent)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Agent' do
        expect do
          post :create, params: { agent: agent_attributes }
        end.to change(Agent, :count).by(1)
      end

      it 'assigns a newly created agent as @agent' do
        post :create, params: { agent: agent_attributes }
        expect(assigns(:agent)).to be_a(Agent)
        expect(assigns(:agent)).to be_persisted
      end

      it 'redirects to the created agent' do
        post :create, params: { agent: agent_attributes }
        expect(response).to redirect_to(Agent.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved agent as @agent' do
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        post :create, params: { agent: { 'name' => 'invalid value' } }
        expect(assigns(:agent)).to be_a_new(Agent)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        post :create, params: { agent: { 'name' => 'invalid value' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested agent' do
        agent = Agent.create! agent_attributes
        expect_any_instance_of(Agent).to receive(:save).at_least(:once)
        put :update, params: { id: agent.to_param, agent: { 'name' => 'MyString' } }
      end

      it 'assigns the requested agent as @agent' do
        agent = Agent.create! agent_attributes
        put :update, params: { id: agent.to_param, agent: agent_attributes }
        expect(assigns(:agent)).to eq(agent)
      end

      it 'redirects to the agent' do
        agent = Agent.create! agent_attributes
        put :update, params: { id: agent.to_param, agent: agent_attributes }
        expect(response).to redirect_to(agent)
      end
    end

    describe 'with invalid params' do
      it 'assigns the agent as @agent' do
        agent = Agent.create! agent_attributes
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        put :update, params: { id: agent.to_param, agent: { 'name' => 'invalid value' } }
        expect(assigns(:agent)).to eq(agent)
      end

      it "re-renders the 'edit' template" do
        agent = Agent.create! agent_attributes
        expect_any_instance_of(Agent).to receive(:save).and_return(false)
        put :update, params: { id: agent.to_param, agent: { 'name' => 'invalid value' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested agent' do
      agent = Agent.create! agent_attributes
      expect do
        delete :destroy, params: { id: agent.to_param }
      end.to change(Agent, :count).by(-1)
    end

    it 'redirects to the agents list' do
      agent = Agent.create! agent_attributes
      delete :destroy, params: { id: agent.to_param }
      expect(response).to redirect_to(agents_url)
    end
  end
end
