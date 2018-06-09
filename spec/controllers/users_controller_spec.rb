# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, office: 1) }
  let(:user1) { FactoryBot.create(:user, office: 2) }

  before(:each) do
    user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      get :index, {}
      expect(response).to be_success
      expect(response).to have_http_status(:success)
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
  end
end
