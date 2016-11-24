# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BprocesController, type: :controller do
  let(:valid_attributes) do
    { name: 'bproce name', shortname: 'sname', fullname: 'fullname 10 symbols' }
  end
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all bproces as @bproces' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('bproces/index')
    end

    it 'loads all of the bproces into @bproces' do
      bproce1 = create(:bproce)
      bproce2 = create(:bproce)
      get :index
      expect(assigns(:bproces)).to match_array([bproce1, bproce2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested bproce as @bproce' do
      metric = create(:metric)
      directive = create(:directive)
      bproce = Bproce.create! valid_attributes
      get :show, { id: bproce.to_param }, valid_session
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'GET new' do
    it 'assigns a new bproce as @bproce' do
      get :new, valid_session
      expect(assigns(:bproce)).to be_a_new(Bproce)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce as @bproce' do
      bproce = Bproce.create! valid_attributes
      get :edit, { id: bproce.to_param }, valid_session
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Bproce' do
        expect do
          post :create, { bproce: valid_attributes }, valid_session
        end.to change(Bproce, :count).by(1)
      end

      it 'assigns a newly created bproce as @bproce' do
        post :create, { bproce: valid_attributes }, valid_session
        expect(assigns(:bproce)).to be_a(Bproce)
        expect(assigns(:bproce)).to be_persisted
      end

      it 'redirects to the created bproce' do
        post :create, { bproce: valid_attributes }, valid_session
        expect(response).to redirect_to(Bproce.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce as @bproce' do
        post :create, { bproce: invalid_attributes }, valid_session
        expect(assigns(:bproce)).to be_a_new(Bproce)
      end

      it "re-renders the 'new' template" do
        post :create, { bproce: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce' do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).at_least(:once)
        put :update, { id: bproce.to_param, bproce: valid_attributes }, valid_session
      end

      it 'assigns the requested bproce as @bproce' do
        bproce = Bproce.create! valid_attributes
        put :update, { id: bproce.to_param, bproce: valid_attributes }, valid_session
        expect(assigns(:bproce)).to eq(bproce)
      end

      it 'redirects to the bproce' do
        bproce = Bproce.create! valid_attributes
        put :update, { id: bproce.to_param, bproce: valid_attributes }, valid_session
        expect(response).to redirect_to(bproce)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce as @bproce' do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, { id: bproce.to_param, bproce: invalid_attributes }, valid_session
        expect(assigns(:bproce)).to eq(bproce)
      end

      it "re-renders the 'edit' template" do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, { id: bproce.to_param, bproce: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce' do
      bproce = Bproce.create! valid_attributes
      expect do
        delete :destroy, { id: bproce.to_param }, valid_session
      end.to change(Bproce, :count).by(-1)
    end

    it 'redirects to the bproces list' do
      bproce = Bproce.create! valid_attributes
      delete :destroy, { id: bproce.to_param }, valid_session
      expect(response).to redirect_to(bproces_url)
    end
  end
end
