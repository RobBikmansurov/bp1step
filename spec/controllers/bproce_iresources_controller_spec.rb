# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BproceIresourcesController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create :bproce, user_id: user.id }
  let(:iresource) { FactoryBot.create :iresource }
  let(:bproce_iresource) { FactoryBot.create :bproce_iresource, bproce_id: bproce.id }
  let(:valid_attributes) { { bproce_id: bproce.id, iresource_id: iresource.id, rpurpose: 'Purpose' } }
  let(:invalid_attributes) { { bproce_id: bproce.id, iresource_id: nil, rpurpose: 'Purpose' } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested bproce_iresource as @bproce_iresource' do
      get :show, params: { id: bproce_iresource.to_param }
      expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
    end
  end

  describe 'GET new' do
    it 'assigns a new bproce_iresource as @bproce_iresource' do
      get :new, params: {}
      expect(assigns(:bproce_iresource)).to be_a_new(BproceIresource)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce_iresource as @bproce_iresource' do
      get :edit, params: { id: bproce_iresource.to_param }
      expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceIresource' do
        expect do
          post :create, params: { bproce_iresource: valid_attributes }
        end.to change(BproceIresource, :count).by(1)
      end

      it 'assigns a newly created bproce_iresource as @bproce_iresource' do
        post :create, params: { bproce_iresource: valid_attributes }
        expect(assigns(:bproce_iresource)).to be_a(BproceIresource)
        expect(assigns(:bproce_iresource)).to be_persisted
      end

      it 'redirects to the created bproce_iresource' do
        post :create, params: { bproce_iresource: valid_attributes }
        expect(response).to redirect_to(BproceIresource.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce_iresource as @bproce_iresource' do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        post :create, params: { bproce_iresource: invalid_attributes }
        expect(assigns(:bproce_iresource)).to be_a_new(BproceIresource)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        post :create, params: { bproce_iresource: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce_iresource' do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, params: { id: bproce_iresource.to_param, bproce_iresource: { 'these' => 'params' } }
      end

      it 'assigns the requested bproce_iresource as @bproce_iresource' do
        put :update, params: { id: bproce_iresource.to_param, bproce_iresource: valid_attributes }
        expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
      end

      it 'redirects to the bproce_iresource' do
        put :update, params: { id: bproce_iresource.to_param, bproce_iresource: valid_attributes }
        expect(response).to redirect_to(bproce_iresource)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce_iresource as @bproce_iresource' do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, params: { id: bproce_iresource.to_param, bproce_iresource: invalid_attributes }
        expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, params: { id: bproce_iresource.to_param, bproce_iresource: invalid_attributes }
        expect(response).to_not render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce_iresource' do
      bproce_iresource = FactoryBot.create :bproce_iresource, bproce_id: bproce.id
      expect do
        delete :destroy, params: { id: bproce_iresource.to_param }
      end.to change(BproceIresource, :count).by(-1)
    end

    it 'redirects to the bproce_iresources list' do
      bproce_iresource = FactoryBot.create :bproce_iresource, bproce_id: bproce.id
      iresource = bproce_iresource.iresource
      delete :destroy, params: { id: bproce_iresource.to_param }
      expect(response).to redirect_to(iresource)
    end
  end
end
