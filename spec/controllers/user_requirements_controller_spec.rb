# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserRequirementsController, type: :controller do
  let(:user)             { FactoryBot.create(:user) }
  let(:author)           { FactoryBot.create(:user) }
  let(:requirement) { FactoryBot.create(:requirement, author_id: author.id) }
  let(:user_requirement) { FactoryBot.create(:user_requirement, user_id: user.id, requirement_id: requirement.id) }
  let(:valid_attributes) { { user_id: user.id, requirement_id: requirement.id, status: 0 } }
  let(:invalid_attributes) { { bproce_id: bproce.id, bapp_id: nil, apurpose: 'Purpose' } }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested user_requirement as @user_requirement' do
      get :show, params: { id: user_requirement.id.to_param }
      expect(assigns(:user_requirement)).to eq(user_requirement)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new UserRequirement' do
        expect do
          post :create, params: { user_requirement: valid_attributes }
        end.to change(UserRequirement, :count).by(1)
      end

      it 'assigns a newly created user_requirement as @user_requirement' do
        post :create, params: { user_requirement: valid_attributes }
        expect(assigns(:user_requirement)).to be_a(UserRequirement)
        expect(assigns(:user_requirement)).to be_persisted
      end

      it 'redirects to the created user_requirement' do
        post :create, params: { user_requirement: valid_attributes }
        expect(response).to redirect_to(UserRequirement.last)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested user_requirement' do
      user_requirement = UserRequirement.create! valid_attributes
      expect do
        delete :destroy, params: { id: user_requirement.to_param }
      end.to change(UserRequirement, :count).by(-1)
    end
  end
end
