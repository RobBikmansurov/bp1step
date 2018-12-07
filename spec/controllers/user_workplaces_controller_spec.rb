# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserWorkplacesController, type: :controller do
  let(:user)           { FactoryBot.create(:user) }
  let(:author)         { FactoryBot.create(:user) }
  let!(:workplace)     { FactoryBot.create(:workplace) }
  let(:user_workplace) { FactoryBot.create(:user_workplace, user_id: user.id, workplace_id: workplace.id) }
  let(:valid_attributes) { { user_id: user.id, workplace_id: workplace.id, note: 'note' } }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested user_workplace as @user_workplace' do
      get :show, params: { id: user_workplace.id.to_param }
      expect(assigns(:user_workplace)).to eq(user_workplace)
    end
  end

  describe 'GET new' do
    it 'assigns a new user_workplace as @user_workplace' do
      get :new, params: {}
      expect(assigns(:user_workplace)).to be_a_new(UserWorkplace)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new UserWorkplace' do
        expect do
          post :create, params: { user_workplace: valid_attributes }
        end.to change(UserWorkplace, :count).by(1)
      end

      it 'assigns a newly created user_workplace as @user_workplace' do
        post :create, params: { user_workplace: valid_attributes }
        expect(assigns(:user_workplace)).to be_a(UserWorkplace)
        expect(assigns(:user_workplace)).to be_persisted
      end

      it 'redirects to the created user_workplace' do
        post :create, params: { user_workplace: valid_attributes }
        expect(response).to redirect_to(UserWorkplace.last)
      end
    end
  end
  describe 'DELETE destroy' do
    it 'destroys the requested user_workplace' do
      user_workplace = UserWorkplace.create! valid_attributes
      expect do
        delete :destroy, params: { id: user_workplace.to_param }
      end.to change(UserWorkplace, :count).by(-1)
    end
  end
end
