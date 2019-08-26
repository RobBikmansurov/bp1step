# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractScansController do
  let(:user) { FactoryBot.create :user }
  let(:agent) { FactoryBot.create(:agent) }
  let(:contract) { FactoryBot.create(:contract, owner_id: user.id, agent_id: agent.id) }
  let!(:contract_scan) { create :contract_scan, contract_id: contract.id }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET edit' do
    it 'assigns the requested metric as @contract' do
      get :edit, params: { id: contract_scan.to_param,
                           contract_scan: { name: 'text' } }
      expect(assigns(:contract_scan)).to eq(contract_scan)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'assigns the requested contract as @contract_scan' do
        put :update, params: { id: contract_scan.to_param,
                               contract_scan: { name: 'text' } }
        expect(assigns(:contract_scan)).to eq(contract_scan)
      end

      it 'redirects to the contract' do
        put :update, params: { id: contract_scan.to_param,
                               contract_scan: { name: 'name' } }
        expect(response).to redirect_to(contract)
      end
    end

    describe 'with invalid params' do
      it 'assigns the contract as @contract_scan' do
        expect_any_instance_of(ContractScan).to receive(:save).and_return(false)
        put :update, params: { id: contract_scan.to_param, contract_scan: { name: '' } }
        expect(assigns(:contract)).to eq(contract)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(ContractScan).to receive(:save).and_return(false)
        put :update, params: { id: contract_scan.to_param, contract_scan: { name: '' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested contract_scan' do
      contract_scan = create :contract_scan, contract_id: contract.id
      expect do
        delete :destroy, params: { id: contract_scan.to_param }
      end.to change(ContractScan, :count).by(-1)
    end

    it 'redirects to the contracts list' do
      delete :destroy, params: { id: contract_scan.to_param }
      expect(response).to redirect_to contract
    end
  end
end
