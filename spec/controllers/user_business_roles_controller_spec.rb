# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserBusinessRolesController, type: :controller do
  let(:user)             { FactoryBot.create(:user) }
  let(:author)           { FactoryBot.create(:user) }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let!(:business_role)            { FactoryBot.create(:business_role, bproce_id: bproce.id) }
  let(:user_business_role)        { FactoryBot.create(:user_business_role, user_id: user.id, business_role_id: business_role.id) }
  let(:valid_attributes) { { user_id: user.id, business_role_id: business_role.id } }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested user_business_role as @user_business_role' do
      get :show, params: { id: user_business_role.id.to_param }
      expect(assigns(:user_business_role)).to eq(user_business_role)
    end
  end

  describe 'GET new' do
    it 'assigns a new user_business_role as @user_business_role' do
      get :new, params: {}
      expect(assigns(:user_business_role)).to be_a_new(UserBusinessRole)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new UserBusinessRole' do
        expect do
          post :create, params: { user_business_role: valid_attributes }
        end.to change(UserBusinessRole, :count).by(1)
      end

      it 'assigns a newly created user_business_role as @user_business_role' do
        post :create, params: { user_business_role: valid_attributes }
        expect(assigns(:user_business_role)).to be_a(UserBusinessRole)
        expect(assigns(:user_business_role)).to be_persisted
      end

      it 'redirects to the created user_business_role' do
        post :create, params: { user_business_role: valid_attributes }
        expect(response).to redirect_to(UserBusinessRole.last.business_role)
      end
    end
  end
  describe 'DELETE destroy' do
    it 'destroys the requested user_business_role' do
      user_business_role = UserBusinessRole.create! valid_attributes
      expect do
        delete :destroy, params: { id: user_business_role.to_param }
      end.to change(UserBusinessRole, :count).by(-1)
    end
  end
end
