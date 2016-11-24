# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BappsController, type: :controller do
  let(:valid_attributes) { { name: 'bapp name', description: 'description' } }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all bapps as @bapps' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('bapps/index')
    end

    it 'loads all of the bapps into @bapps' do
      bapp1 = FactoryGirl.create(:bapp)
      bapp2 = FactoryGirl.create(:bapp)
      get :index
      expect(assigns(:bapps)).to match_array([bapp1, bapp2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested bapp as @bapp' do
      bapp = Bapp.create! valid_attributes
      get :show, { id: bapp.to_param }, valid_session
      expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe 'GET new' do
    it 'assigns a new bapp as @bapp' do
      get :new, valid_session
      expect(assigns(:bapp)).to be_a_new(Bapp)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bapp as @bapp' do
      bapp = Bapp.create! valid_attributes
      get :edit, { id: bapp.to_param }, valid_session
      expect(assigns(:bapp)).to eq(bapp)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Bapp' do
        expect do
          post :create, { bapp: valid_attributes }, valid_session
        end.to change(Bapp, :count).by(1)
      end

      it 'assigns a newly created bapp as @bapp' do
        post :create, { bapp: valid_attributes }, valid_session
        expect(assigns(:bapp)).to be_a(Bapp)
        expect(assigns(:bapp)).to be_persisted
      end

      it 'redirects to the created bapp' do
        post :create, { bapp: valid_attributes }, valid_session
        expect(response).to redirect_to(Bapp.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bapp as @bapp' do
        post :create, { bapp: invalid_attributes }, valid_session
        expect(assigns(:bapp)).to be_a_new(Bapp)
      end

      it "re-renders the 'new' template" do
        post :create, { bapp: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bapp' do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).at_least(:once)
        put :update, { id: bapp.to_param, bapp: valid_attributes }, valid_session
      end

      it 'assigns the requested bapp as @bapp' do
        bapp = Bapp.create! valid_attributes
        put :update, { id: bapp.to_param, bapp: valid_attributes }, valid_session
        expect(assigns(:bapp)).to eq(bapp)
      end

      it 'redirects to the bapp' do
        bapp = Bapp.create! valid_attributes
        put :update, { id: bapp.to_param, bapp: valid_attributes }, valid_session
        expect(response).to redirect_to(bapp)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bapp as @bapp' do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, { id: bapp.to_param, bapp: invalid_attributes }, valid_session
        expect(assigns(:bapp)).to eq(bapp)
      end

      it "re-renders the 'edit' template" do
        bapp = Bapp.create! valid_attributes
        expect_any_instance_of(Bapp).to receive(:save).and_return(false)
        put :update, { id: bapp.to_param, bapp: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bapp' do
      bapp = Bapp.create! valid_attributes
      expect do
        delete :destroy, { id: bapp.to_param }, valid_session
      end.to change(Bapp, :count).by(-1)
    end

    it 'redirects to the bapps list' do
      bapp = Bapp.create! valid_attributes
      delete :destroy, { id: bapp.to_param }, valid_session
      expect(response).to redirect_to(bapps_url)
    end
  end
end
