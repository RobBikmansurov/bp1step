# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractsController do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let(:agent) { FactoryBot.create(:agent) }
  let(:valid_attributes) do
    { number: '1', name: 'name', status: 'status', description: 'description',
      owner_id: user.id, agent_id: agent.id, contract_type: 'Договор' }
  end
  let(:valid_session) { {} }
  let(:valid_contracts)  { FactoryBot.create_list(:contract, 2) }
  let(:invalid_contract) { FactoryBot.create(:contract, :invalid) }
  let(:contract) { FactoryBot.create(:contract, owner_id: user.id, agent_id: agent.id) }
  let(:bproce_contract) { FactoryBot.create(:bproce_contract, bproce_id: bproce.id, contract_id: contract.id) }
  let(:current_user) { FactoryBot.create(:user, position: 'big_boss') }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all contracts as @contracts' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('contracts/index')
    end

    it 'loads all of the contracts into @contracts' do
      contracts = [
        FactoryBot.create(:contract, owner_id: user.id, agent_id: agent.id),
        FactoryBot.create(:contract, owner_id: user.id, agent_id: agent.id)
      ]
      get :index
      expect(assigns(:contracts)).to match_array(contracts)
    end

    it 'returns contracts with status' do
      contract_w_status = FactoryBot.create :contract, owner_id: user.id, agent_id: agent.id, status: 'Согласование'
      get :index, params: { status: 'Согласование' }
      expect(assigns(:contracts)).to match_array([contract_w_status])
    end

    it 'returns contracts for bproce' do
      bproce1 = FactoryBot.create :bproce, user_id: user.id
      contract1 = FactoryBot.create :contract, owner_id: user.id, agent_id: agent.id
      bproce_contract1 = FactoryBot.create :bproce_contract, bproce_id: bproce1.id, contract_id: contract1.id
      get :index, params: { bproce_id: bproce1.to_param }
      expect(assigns(:contracts)).to match_array([contract1])
    end

    it 'returns contracts for bproce and status' do
      bproce1 = FactoryBot.create :bproce, user_id: user.id
      contract1 = FactoryBot.create :contract, owner_id: user.id, agent_id: agent.id, status: 'Привет'
      bproce_contract1 = FactoryBot.create :bproce_contract, bproce_id: bproce1.id, contract_id: contract1.id
      get :index, params: { bproce_id: bproce1.to_param, status: 'Привет' }
      expect(assigns(:contracts)).to match_array([contract1])
    end

    it 'returns contracts with type' do
      contract_with_type = FactoryBot.create :contract, owner_id: user.id, agent_id: agent.id, contract_type: 'AnyType'
      get :index, params: { type: 'AnyType' }
      expect(assigns(:contracts)).to match_array([contract_with_type])
    end

    it 'returns contracts with place' do
      contract_with_place = FactoryBot.create :contract, owner_id: user.id, agent_id: agent.id, contract_place: 'Place'
      get :index, params: { place: 'Place' }
      expect(assigns(:contracts)).to match_array([contract_with_place])
    end

    it 'returns contracts for user' do
      user1 = FactoryBot.create :user
      contract_users = FactoryBot.create :contract, owner_id: user1.id, agent_id: agent.id
      get :index, params: { user: user1.id }
      expect(assigns(:contracts)).to match_array([contract_users])
    end

    it 'returns contracts for payer' do
      payer = FactoryBot.create :user
      contract_payers = FactoryBot.create :contract, owner_id: user.id, payer_id: payer.id, agent_id: agent.id
      get :index, params: { payer: payer.id }
      expect(assigns(:contracts)).to match_array([contract_payers])
    end
  end

  describe 'GET show' do
    it 'assigns the requested contract as @contract' do
      get :show, params: { id: contract.to_param }
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe 'GET new' do
    it 'assigns a new contract as @contract' do
      get :new, params: {}
      expect(assigns(:contract)).to be_a_new(Contract)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested contract as @contract' do
      contract = Contract.create! valid_attributes
      get :edit, params: { id: contract.to_param }
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Contract' do
        expect do
          post :create, params: { contract: valid_attributes }
        end.to change(Contract, :count).by(1)
      end

      it 'assigns a newly created contract as @contract' do
        post :create, params: { contract: valid_attributes }
        expect(assigns(:contract)).to be_a(Contract)
        expect(assigns(:contract)).to be_persisted
      end

      it 'redirects to the created contract' do
        post :create, params: { contract: valid_attributes }
        expect(response).to redirect_to(Contract.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved contract as @contract' do
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        post :create, params: { contract: { 'owner_id' => 'invalid value' } }
        expect(assigns(:contract)).to be_a_new(Contract)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        post :create, params: { contract: { 'owner_id' => 'invalid value' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested contract' do
        contract = Contract.create! valid_attributes
        expect_any_instance_of(Contract).to receive(:save).at_least(:once)
        put :update, params: { id: contract.to_param, contract: { 'owner_id' => '' } }
      end

      it 'assigns the requested contract as @contract' do
        contract = Contract.create! valid_attributes
        user = FactoryBot.create(:user)
        contract.owner_id = user.id
        contract.payer_id = user.id
        contract.save
        put :update, params: { id: contract.to_param,
                               contract: { number: '1', name: 'name', status: 'status', description: 'description',
                                           owner_id: user.id, contract_type: 'Договор' } }
        expect(assigns(:contract)).to eq(contract)
      end

      it 'redirects to the contract' do
        contract = Contract.create! valid_attributes
        user = FactoryBot.create(:user)
        contract.owner_id = user.id
        contract.payer_id = user.id
        contract.save
        put :update, params: { id: contract.to_param,
                               contract: { number: '1', name: 'name', status: 'status', description: 'description',
                                           owner_id: user.id, contract_type: 'Договор' } }
        expect(response).to redirect_to(contract)
      end
    end

    describe 'with invalid params' do
      it 'assigns the contract as @contract' do
        contract = Contract.create! valid_attributes
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        put :update, params: { id: contract.to_param, contract: { 'owner_id' => 'invalid value' } }
        expect(assigns(:contract)).to eq(contract)
      end

      it "re-renders the 'edit' template" do
        contract = Contract.create! valid_attributes
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        put :update, params: { id: contract.to_param, contract: { 'owner_id' => 'invalid value' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested contract' do
      contract = Contract.create! valid_attributes
      expect do
        delete :destroy, params: { id: contract.to_param }
      end.to change(Contract, :count).by(-1)
    end

    it 'redirects to the contracts list' do
      contract = Contract.create! valid_attributes
      delete :destroy, params: { id: contract.to_param }
      expect(response).to redirect_to(contracts_url)
    end
  end

  it 'return clone' do
    bproce_contract = FactoryBot.create :bproce_contract, bproce_id: bproce.id, contract_id: contract.id
    get :clone, params: { id: contract.to_param }
    expect(response).to render_template('contracts/clone')
  end

  it 'update_scan' do
    contract_scan = FactoryBot.create :contract_scan, contract_id: contract.id
    # post :update_scan, params: { contract_scan: contract_scan }
    # expect(response).to render_template('show')
  end

  describe 'reports' do
    it 'render approval_sheet' do
      current_user = FactoryBot.create :user
      bproce_contract = FactoryBot.create :bproce_contract, bproce_id: bproce.id, contract_id: contract.id
      get :approval_sheet, params: { id: contract.to_param }
      expect(response).to be_successful
    end

    it 'print' do
      get :index, params: { format: 'odt' }
      expect(response).to be_successful
    end
  end
end
