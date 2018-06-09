# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BproceBappsController, type: :controller do
  let(:owner)            { FactoryBot.create(:user) }
  let(:role)             { FactoryBot.create(:role, name: 'author', description: 'Автор') }
  let!(:bproce)          { FactoryBot.create(:bproce, user_id: owner.id) }
  let!(:bapp)            { FactoryBot.create(:bapp) }
  let(:valid_attributes) { { bproce_id: bproce.id, bapp_id: bapp.id, apurpose: 'Purpose' } }
  let(:invalid_attributes) { { bproce_id: bproce.id, bapp_id: nil, apurpose: 'Purpose' } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested bproce_bapp as @bproce_bapp' do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :show, params: { id: bproce_bapp.id.to_param }
      expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce_bapp as @bproce_bapp' do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :edit, params: { id: bproce_bapp.to_param }
      expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceBapp' do
        expect do
          post :create, params: { bproce_bapp: valid_attributes }
        end.to change(BproceBapp, :count).by(1)
      end

      it 'assigns a newly created bproce_bapp as @bproce_bapp' do
        post :create, params: { bproce_bapp: valid_attributes }
        expect(assigns(:bproce_bapp)).to be_a(BproceBapp)
        expect(assigns(:bproce_bapp)).to be_persisted
      end

      it 'redirects to the created bproce_bapp' do
        post :create, params: { bproce_bapp: valid_attributes }
        expect(response).to redirect_to(BproceBapp.last.bapp)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce_bapp as @bproce_bapp' do
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        post :create, params: { bproce_bapp: { bproce_id: bproce.id, bapp_id: nil, apurpose: 'Purpose' } }
        expect(assigns(:bproce_bapp)).to be_a_new(BproceBapp)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce_bapp' do
        bproce_bapp = BproceBapp.create! valid_attributes
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        put :update, params: { id: bproce_bapp.to_param, bproce_bapp: { 'these' => 'params' } }
      end

      it 'assigns the requested bproce_bapp as @bproce_bapp' do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, params: { id: bproce_bapp.to_param, bproce_bapp: valid_attributes }
        expect(assigns(:bproce_bapp)).to eq(bproce_bapp)
      end

      it 'redirects to the bproce_bapp' do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, params: { id: bproce_bapp.to_param, bproce_bapp: valid_attributes }
        expect(response).to redirect_to(bproce_bapp)
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'edit' template" do
        bproce_bapp = BproceBapp.create! valid_attributes
        expect_any_instance_of(BproceBapp).to receive(:save).and_return(false)
        bproce = create(:bproce, user_id: owner.id)
        bapp = create(:bapp)
        bproce_bapp.bproce_id = bproce.id
        bproce_bapp.bapp_id = bapp.id
        put :update, params: { id: bproce_bapp.to_param, bproce_bapp: invalid_attributes }
        expect(response).to redirect_to bproce_bapp_url # render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce_bapp' do
      bproce_bapp = BproceBapp.create! valid_attributes
      bproce = create(:bproce, user_id: owner.id)
      bapp = create(:bapp)
      bproce_bapp.bproce_id = bproce.id
      bproce_bapp.bapp_id = bapp.id
      expect do
        delete :destroy, params: { id: bproce_bapp.to_param, bproce_id: bproce.to_param }
      end.to change(BproceBapp, :count).by(-1)
    end

    it 'redirects to the bproce_bapps list' do
      bproce_bapp = BproceBapp.create! valid_attributes
      delete :destroy, params: { id: bproce_bapp.to_param }
      expect(response).to redirect_to bapp_url
    end
  end
end
