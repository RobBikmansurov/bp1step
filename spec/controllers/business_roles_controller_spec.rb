# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BusinessRolesController, type: :controller do
  let(:valid_attributes) { { name: 'busines_roles name', description: 'roles description', bproce_id: 1 } }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all business_roles as @business_roles' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('business_roles/index')
    end

    it 'loads all of the business_roles into @business_roles' do
      busines_roles1 = FactoryGirl.create(:business_roles)
      busines_roles2 = BusinessRole.create! valid_attributes
      get :index
      expect(assigns(:business_roles)).to match_array([busines_roles1, busines_roles2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested busines_roles as @busines_roles' do
      busines_roles = BusinessRole.create! valid_attributes
      get :show, { id: busines_roles.to_param }, valid_session
      expect(assigns(:busines_roles)).to eq(busines_roles)
    end
  end

  describe 'GET new' do
    it 'assigns a new busines_roles as @busines_roles' do
      get :new, valid_session
      expect(assigns(:busines_roles)).to be_a_new(BusinessRole)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested busines_roles as @busines_roles' do
      busines_roles = BusinessRole.create! valid_attributes
      get :edit, { id: busines_roles.to_param }, valid_session
      expect(assigns(:busines_roles)).to eq(busines_roles)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BusinessRole' do
        expect do
          post :create, { busines_roles: valid_attributes }, valid_session
        end.to change(BusinessRole, :count).by(1)
      end

      it 'assigns a newly created busines_roles as @busines_roles' do
        post :create, { busines_roles: valid_attributes }, valid_session
        expect(assigns(:busines_roles)).to be_a(BusinessRole)
        expect(assigns(:busines_roles)).to be_persisted
      end

      it 'redirects to the created busines_roles' do
        post :create, { busines_roles: valid_attributes }, valid_session
        expect(response).to redirect_to(BusinessRole.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved busines_roles as @busines_roles' do
        post :create, { busines_roles: invalid_attributes }, valid_session
        expect(assigns(:busines_roles)).to be_a_new(BusinessRole)
      end

      it "re-renders the 'new' template" do
        post :create, { busines_roles: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested busines_roles' do
        busines_roles = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).at_least(:once)
        put :update, { id: busines_roles.to_param, busines_roles: valid_attributes }, valid_session
      end

      it 'assigns the requested busines_roles as @busines_roles' do
        busines_roles = BusinessRole.create! valid_attributes
        put :update, { id: busines_roles.to_param, busines_roles: valid_attributes }, valid_session
        expect(assigns(:busines_roles)).to eq(busines_roles)
      end

      it 'redirects to the busines_roles' do
        busines_roles = BusinessRole.create! valid_attributes
        put :update, { id: busines_roles.to_param, busines_roles: valid_attributes }, valid_session
        expect(response).to redirect_to(busines_roles)
      end
    end

    describe 'with invalid params' do
      it 'assigns the busines_roles as @busines_roles' do
        busines_roles = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).and_return(false)
        put :update, { id: busines_roles.to_param, busines_roles: invalid_attributes }, valid_session
        expect(assigns(:busines_roles)).to eq(busines_roles)
      end

      it "re-renders the 'edit' template" do
        busines_roles = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).and_return(false)
        put :update, { id: busines_roles.to_param, busines_roles: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested busines_roles' do
      busines_roles = BusinessRole.create! valid_attributes
      expect do
        delete :destroy, { id: busines_roles.to_param }, valid_session
      end.to change(BusinessRole, :count).by(-1)
    end

    it 'redirects to the business_roles list' do
      busines_roles = BusinessRole.create! valid_attributes
      delete :destroy, { id: busines_roles.to_param }, valid_session
      expect(response).to redirect_to(business_roles_url)
    end
  end
end
