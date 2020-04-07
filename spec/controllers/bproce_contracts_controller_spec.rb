# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BproceContractsController, type: :controller do
  let(:owner)            { FactoryBot.create(:user) }
  let(:role)             { FactoryBot.create(:role, name: 'author', description: 'Автор') }
  let!(:bproce)          { FactoryBot.create(:bproce, user_id: owner.id) }
  let!(:agent)           { FactoryBot.create(:agent) }
  let!(:contract)        { FactoryBot.create(:contract, agent_id: agent.id, owner_id: owner.id) }
  let(:bproce_contract)  { FactoryBot.create(:bproce_contract, bproce_id: bproce.id, contract_id: contract.id) }
  let(:valid_attributes) { { bproce_id: bproce.id, contract_id: contract.id } }
  let(:add_proce_to_contract) { { contract_id: contract.id, bproce_name: bproce.name } }
  let(:add_contract_to_proce) { { bproce_id: bproce.id, contract_description: contract.description } }
  let(:valid_attributes_w_name) { { bproce_name: bproce.name, contract_id: contract.id } }
  let(:valid_session) { {} }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested bproce_contract.contract as @contract' do
      get :show, params: { id: bproce_contract.to_param }
      expect(assigns(:bproce_contract)).to eq(bproce_contract)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceCiontract' do
        expect do
          post :create, params: { bproce_contract: add_proce_to_contract }
        end.to change(BproceContract, :count).by(1)
      end

      it 'assigns a newly created bproce_contract as @bproce_contract' do
        post :create, params: { bproce_contract: add_proce_to_contract }
        expect(assigns(:bproce_contract)).to be_a(BproceContract)
        expect(assigns(:bproce_contract)).to be_persisted
      end

      it 'redirects to the created bproce_contract with bproce_id and contract_id' do
        post :create, params: { bproce_contract: add_proce_to_contract }
        expect(response).to redirect_to(BproceContract.last.contract)
      end

      it 'redirects to the created bproce_contract with bproce_name and contract_id' do
        post :create, params: { bproce_contract: valid_attributes_w_name }
        expect(response).to redirect_to(BproceContract.last.contract)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce_contract if it have > 1 processes' do
      _bproce_contract1 = FactoryBot.create(:bproce_contract, bproce_id: bproce.id, contract_id: contract.id)
      bproce2 = FactoryBot.create(:bproce, user_id: owner.id)
      bproce_contract2 = FactoryBot.create(:bproce_contract, bproce_id: bproce2.id, contract_id: contract.id)
      expect do
        delete :destroy, params: { id: bproce_contract2.to_param } # , bproce_id: bproce.to_param }
      end.to change(BproceContract, :count).by(-1)
      expect(flash[:notice]).to be_present
    end

    it 'redirects to the bproce_contracts list' do
      bproce_contract1 = FactoryBot.create(:bproce_contract, bproce_id: bproce.id, contract_id: contract.id)
      delete :destroy, params: { id: bproce_contract1.to_param }
      expect(response).to redirect_to contract
    end
  end
end
