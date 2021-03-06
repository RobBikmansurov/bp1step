# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BproceWorkplacesController, type: :controller do
  let(:owner)            { FactoryBot.create(:user) }
  let(:role)             { FactoryBot.create(:role, name: 'author', description: 'Автор') }
  let!(:bproce)          { FactoryBot.create(:bproce, user_id: owner.id) }
  let!(:workplace)       { FactoryBot.create(:workplace) }
  let(:bproce_workplace) { FactoryBot.create(:bproce_workplace, bproce_id: bproce.id, workplace_id: workplace.id) }
  let(:valid_attributes) { { bproce_id: bproce.id, workplace_id: workplace.id } }
  let(:add_proce_to_workplace) { { workplace_id: workplace.id, bproce_name: bproce.name } }
  let(:add_workplace_to_proce) { { bproce_id: bproce.id, workplace_designation: workplace.designation } }
  let(:valid_attributes_w_name) { { bproce_name: bproce.name, workplace_id: workplace.id } }
  let(:valid_session) { {} }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do # show показывает список рабочих мест!
    it 'assigns the requested bproce_workplace.workplace as @workplace' do
      get :show, params: { id: bproce.to_param }
      expect(assigns(:workplaces)).to eq(bproce.workplaces)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceWorkplace by add bproce_name' do
        expect do
          post :create, params: { bproce_workplace: add_proce_to_workplace }
        end.to change(BproceWorkplace, :count).by(1)
      end

      it 'creates a new BproceWorkplace by add workplace_designation' do
        expect do
          post :create, params: { bproce_workplace: add_workplace_to_proce }
        end.to change(BproceWorkplace, :count).by(1)
      end

      it 'assigns a newly created bproce_workplace as @bproce_workplace' do
        post :create, params: { bproce_workplace: add_proce_to_workplace }
        expect(assigns(:bproce_workplace)).to be_a(BproceWorkplace)
        expect(assigns(:bproce_workplace)).to be_persisted
      end

      it 'redirects to the created bproce_workplace with bproce_id and workplace_id' do
        post :create, params: { bproce_workplace: add_proce_to_workplace }
        expect(response).to redirect_to(BproceWorkplace.last.workplace)
      end

      it 'redirects to the created bproce_workplace with bproce_name and workplace_id' do
        post :create, params: { bproce_workplace: valid_attributes_w_name }
        expect(response).to redirect_to(BproceWorkplace.last.workplace)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce_workplace' do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      bproce = create(:bproce, user_id: owner.id)
      workplace = create(:workplace)
      bproce_workplace.bproce_id = bproce.id
      bproce_workplace.workplace_id = workplace.id
      expect do
        delete :destroy, params: { id: bproce_workplace.to_param, bproce_id: bproce.to_param }
      end.to change(BproceWorkplace, :count).by(-1)
    end

    it 'redirects to the bproce_workplaces list' do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      workplace = bproce_workplace.workplace
      delete :destroy, params: { id: bproce_workplace.to_param }
      expect(response).to redirect_to workplace
    end
  end
end
