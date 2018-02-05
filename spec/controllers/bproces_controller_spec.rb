# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BprocesController, type: :controller do
  let(:valid_attributes) {    { name: 'bproce name', shortname: 'sname', fullname: 'fullname 10 symbols' }   }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all bproces as @bproces' do
      get :index, params: {}
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
      get :show, params: { id: bproce.to_param }
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'GET new' do
    it 'assigns a new bproce as @bproce' do
      get :new
      expect(assigns(:bproce)).to be_a_new(Bproce)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce as @bproce' do
      bproce = Bproce.create! valid_attributes
      get :edit, params: { id: bproce.to_param }
      expect(assigns(:bproce)).to eq(bproce)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Bproce' do
        expect do
          post :create, params: { bproce: valid_attributes }
        end.to change(Bproce, :count).by(1)
      end

      it 'assigns a newly created bproce as @bproce' do
        post :create, params: { bproce: valid_attributes }
        expect(assigns(:bproce)).to be_a(Bproce)
        expect(assigns(:bproce)).to be_persisted
      end

      it 'redirects to the created bproce' do
        post :create, params: { bproce: valid_attributes }
        expect(response).to redirect_to(Bproce.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce as @bproce' do
        post :create, params: { bproce: invalid_attributes }
        expect(assigns(:bproce)).to be_a_new(Bproce)
      end

      it "re-renders the 'new' template" do
        post :create, params: { bproce: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce' do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).at_least(:once)
        put :update, params: { id: bproce.to_param, bproce: valid_attributes }
      end

      it 'assigns the requested bproce as @bproce' do
        bproce = Bproce.create! valid_attributes
        put :update, params: { id: bproce.to_param, bproce: valid_attributes }
        expect(assigns(:bproce)).to eq(bproce)
      end

      it 'redirects to the bproce' do
        bproce = Bproce.create! valid_attributes
        put :update, params: { id: bproce.to_param, bproce: valid_attributes }
        expect(response).to redirect_to(bproce)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce as @bproce' do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, params: { id: bproce.to_param, bproce: invalid_attributes }
        expect(assigns(:bproce)).to eq(bproce)
      end

      it "re-renders the 'edit' template" do
        bproce = Bproce.create! valid_attributes
        expect_any_instance_of(Bproce).to receive(:save).and_return(false)
        put :update, params: { id: bproce.to_param, bproce: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested bproce' do
      bproce = FactoryBot.create :bproce
      # bapp = FactoryBot.create :bapp, bproce_id: bproce.id
      expect do
        delete :destroy, params: { id: bproce.to_param }
      end.to change(Bproce, :count).by(-1)
    end

    it 'redirects to the bproces list' do
      bproce = FactoryBot.create :bproce
      # bapp = FactoryBot.create :bapp, bproce_id: bproce.id
      delete :destroy, params: { id: bproce.to_param }
      expect(response).to redirect_to(bproces_url)
    end
  end
end
