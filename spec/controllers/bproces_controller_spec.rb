# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BprocesController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:user1) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create :bproce, user_id: user.id }
  let(:bproce1) { FactoryBot.create :bproce, user_id: user1.id }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
    # controller.stub(:current_user).and_return @admin
  end

  describe 'GET index' do
    it 'assigns all bproces as @bproces' do
      get :index, params: {}
      expect(response).to be_successful
      expect(response).to render_template('bproces/index')
    end

    it 'returns finded processes with param search' do
      bproce.name = 'sms-information'
      get :index, params: { search: 'sms' }
      # expect(assigns(:bproces)).to match_array([bproce])
    end

    it 'loads all bprocesses into @bproces' do
      get :index, params: {}
      expect(assigns(:bproces)).to match_array([bproce, bproce1])
    end

    it 'loads all bprocesses with params all' do
      get :index, params: { all: 1 }
      expect(assigns(:bproces)).to match_array([bproce, bproce1])
    end

    it 'loads all bprocesses with params all' do
      get :index, params: { tag: 'web' }
      # expect(assigns(:bproces)).to match_array([bproce, bproce1])
    end

    it 'loads bproceses for user' do
      bproce_u = FactoryBot.create :bproce, user_id: user1.id
      get :index, params: { user: user1.id }
      expect(assigns(:bproces)).to match_array([bproce_u])
    end
  end

  describe 'GET show' do
    it 'assigns the requested bproce as @bproce' do
      # metric = create(:metric, bproce_id: bproce.id)
      # directive = create(:directive)
      get :show, params: { id: bproce.to_param }
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'GET new_sub_process' do
    it 'assigns a new sub_bproce as @bproce' do
      get :new_sub_process, params: { id: bproce.to_param }
      expect(assigns(:bproce)).to be_a_new(Bproce)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce as @bproce' do
      get :edit, params: { id: bproce.to_param }
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Bproce' do
        expect do
          post :create, params: { bproce: bproce.attributes }
        end.to change(Bproce, :count).by(1)
      end

      it 'assigns a newly created bproce as @bproce' do
        post :create, params: { bproce: bproce.attributes }
        expect(assigns(:bproce)).to be_a(Bproce)
      end

      it 'saves goal in created bproce' do
        bproce.goal = 'Goal of bproce'
        post :create, params: { bproce: bproce.attributes }
        expect(bproce.goal).to eq('Goal of bproce')
      end

      it 'saves owner in created bproce' do
        user = FactoryBot.create(:user)
        bproce.user_id = user.id
        post :create, params: { bproce: bproce.attributes }
        expect(bproce.user.displayname).to eq(user.displayname)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce as @bproce' do
        post :create, params: { bproce: invalid_attributes }
        expect(assigns(:bproce)).to be_a_new(Bproce)
      end

      it "re-renders the 'new_sub_process' template" do
        post :create, params: { bproce: invalid_attributes }
        expect(response).to render_template('new_sub_process')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce' do
        put :update, params: { id: bproce.to_param, bproce: bproce.attributes }
        expect(response).to redirect_to(bproce)
      end

      it 'assigns the requested bproce as @bproce' do
        put :update, params: { id: bproce.id.to_param, bproce: bproce.attributes }
        expect(assigns(:bproce)).to eq(bproce)
      end

      it 'redirects to the bproce' do
        put :update, params: { id: bproce.to_param, bproce: bproce.attributes }
        expect(response).to redirect_to(bproce)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce as @bproce' do
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, params: { id: bproce.to_param, bproce: invalid_attributes }
        expect(assigns(:bproce)).to eq(bproce)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, params: { id: bproce.to_param, bproce: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce' do
      # expect do
      #   delete :destroy, params: { id: bproce.to_param }
      # end.to change(Bproce, :count).by(-1)
    end

    it 'redirects to the bproces list' do
      delete :destroy, params: { id: bproce.to_param }
      expect(response).to redirect_to(bproces_url)
    end
  end

  describe 'reports' do
    let!(:bproce_sub) { create :bproce, user_id: user1.id, parent_id: bproce.id }
    let(:bapp) { create :bapp }
    let!(:bproce_bapp) { create :bproce_bapp, bproce_id: bproce.id, bapp_id: bapp.id }
    let!(:metric) { create :metric, bproce_id: bproce.id }
    let(:agent) { create(:agent) }
    let(:contract) { create(:contract, owner_id: user.id, agent_id: agent.id) }
    let!(:bproce_contract) { create :bproce_contract, bproce_id: bproce.id, contract_id: contract.id }
    let(:workplace) { create :workplace }
    let!(:bproce_workplace) { create :bproce_workplace, bproce_id: bproce.id, workplace_id: workplace.id }
    let(:document) { create :document, owner_id: user.id, status: 'Действует' }
    let!(:bproce_document)  { create :bproce_document, bproce_id: bproce.id, document_id: document.id }

    it 'check_list' do
      get :check_list, params: { id: bproce.to_param }
      expect(response).to be_successful
    end

    it 'check_list_improve' do
      get :check_list_improve, params: { id: bproce.to_param }
      expect(response).to be_successful
    end

    it 'doc' do
      get :doc, params: { id: bproce.to_param }
      expect(response).to be_successful
    end

    it 'order' do
      get :order, params: { id: bproce.to_param }
      expect(response).to be_successful
    end

    it 'card' do
      get :card, params: { id: bproce.to_param }
      expect(response).to be_successful
    end

    it 'print' do
      get :index, params: { id: bproce.to_param, format: 'pdf' }
      expect(response).to be_successful
    end
  end
end
