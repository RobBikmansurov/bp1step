# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, office: 1) }
  let(:user1) { FactoryBot.create(:user, office: 2) }

  before do
    user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('users/index')
    end

    it 'lists all users' do
      get :index
      expect(assigns(:users)).to match_array([user, user1])
    end
    it 'lists users from office' do
      get :index
      expect(assigns(:users)).to match_array([user, user1])

      get :index, params: { office: 1 }
      expect(assigns(:users)).to match_array([user])
      get :index, params: { office: 2 }
      expect(assigns(:users)).to match_array([user1])
    end
    it 'lists users with role' do
      get :index, params: { role: 'admin' }
      expect(assigns(:users)).to match_array([user])
    end
    it 'stop all business roles' do
      get :stop_all, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
    it 'documents_move_to' do
      new_user = FactoryBot.create :user
      post :documents_move_to, params: { id: user.id, user: {user_name: new_user.displayname } }
      expect(response).to redirect_to(new_user)
    end
    it 'business_roles_move_to' do
      new_user = FactoryBot.create :user
      post :business_roles_move_to, params: { id: user.id, user: {user_name: new_user.displayname } }
      expect(response).to render_template(:edit)
    end
    it 'render uworkplaces' do
      get :uworkplaces, params: { id: user.id }
      expect(response).to render_template :uworkplaces
    end
    it 'render uroles' do
      get :uroles, params: { id: user.id }
      expect(response).to render_template :uroles
    end
    it 'render documents' do
      get :documents, params: { id: user.id }
      expect(response).to render_template :documents
    end
    it 'render documents' do
      get :documents, params: { id: user.id }
      expect(response).to render_template :documents
    end
    it 'render documents' do
      get :documents, params: { id: user.id }
      expect(response).to render_template :documents
    end
    it 'render processes' do
      get :processes, params: { id: user.id }
      expect(response).to render_template :processes
    end
  end
end
