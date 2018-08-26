# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BappsController, type: :controller do
  let(:bapp_attributes) { { name: 'bapp name', description: 'description' } }
  let(:inbapp_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  let(:bapp) { FactoryBot.create :bapp }
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all bapps as @bapps' do
      get :index, {}
      expect(response).to be_successful
      expect(response).to render_template('bapps/index')
    end

    it 'loads all of the bapps into @bapps' do
      bapp1 = FactoryBot.create :bapp
      bapp2 = FactoryBot.create :bapp
      get :index
      expect(assigns(:bapps)).to match_array([bapp1, bapp2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested bapp as @bapp' do
      bapp = Bapp.create! bapp_attributes
      get :show, params: { id: bapp.to_param }
      expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe 'GET new' do
    it 'assigns a new bapp as @bapp' do
      get :new
      expect(assigns(:bapp)).to be_a_new(Bapp)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bapp as @bapp' do
      bapp = Bapp.create! bapp_attributes
      get :edit, params: { id: bapp.to_param }
      expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Bapp' do
        expect do
          post :create, params: { bapp: bapp_attributes }
        end.to change(Bapp, :count).by(1)
      end

      it 'assigns a newly created bapp as @bapp' do
        post :create, params: { bapp: bapp_attributes }
        expect(assigns(:bapp)).to be_a(Bapp)
        expect(assigns(:bapp)).to be_persisted
      end

      it 'redirects to the created bapp' do
        post :create, params: { bapp: bapp_attributes }
        expect(response).to redirect_to(Bapp.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bapp as @bapp' do
        post :create, params: { bapp: inbapp_attributes }
        expect(assigns(:bapp)).to be_a_new(Bapp)
      end

      it "re-renders the 'new' template" do
        post :create, params: { bapp: inbapp_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bapp' do
        bapp = Bapp.create! bapp_attributes
        expect_any_instance_of(Bapp).to receive(:save).at_least(:once)
        put :update, params: { id: bapp.to_param, bapp: bapp_attributes }
      end

      it 'assigns the requested bapp as @bapp' do
        bapp = Bapp.create! bapp_attributes
        put :update, params: { id: bapp.to_param, bapp: bapp_attributes }
        expect(assigns(:bapp)).to eq(bapp)
      end

      it 'redirects to the bapp' do
        bapp = Bapp.create! bapp_attributes
        put :update, params: { id: bapp.to_param, bapp: bapp_attributes }
        expect(response).to redirect_to(bapp)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bapp as @bapp' do
        bapp = Bapp.create! bapp_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, params: { id: bapp.to_param, bapp: inbapp_attributes }
        expect(assigns(:bapp)).to eq(bapp)
      end

      it "re-renders the 'edit' template" do
        bapp = Bapp.create! bapp_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, params: { id: bapp.to_param, bapp: inbapp_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bapp' do
      bapp = Bapp.create! bapp_attributes
      expect do
        delete :destroy, params: { id: bapp.to_param }
      end.to change(Bapp, :count).by(-1)
    end

    it 'redirects to the bapps list' do
      bapp = Bapp.create! bapp_attributes
      delete :destroy, params: { id: bapp.to_param }
      expect(response).to redirect_to(bapps_url)
    end
  end
end
