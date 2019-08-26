# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, office: 1) }
  let(:user1) { FactoryBot.create(:user, office: 2) }
  let(:bproce) { create :bproce, user_id: user.id }
  let(:document) { create :document, owner: user }

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
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested user' do
        expect_any_instance_of(User).to receive(:save).at_least(:once)
        put :update, params: { id: user.to_param,
                               user: { position: 'Должность' } }
      end
      it 'assigns the requested user' do
        put :update, params: { id: user.to_param,
                               user: { position: 'Должность' } }
        expect(response).to redirect_to user
      end
    end
  end

  it 'stop all business roles' do
    get :stop_all, params: { id: user.id }
    expect(response).to render_template(:edit)
  end

  # it 'render move_documents_to' do
  #   get :move_documents_to, params: { id: user1.id }
  #   expect(response.status).to render_template :partial => 'move_documents_to'
  # end
  it 'documents_move_to' do
    user_document = UserDocument.create user: user, document: document
    new_user = FactoryBot.create :user
    post :documents_move_to, params: { id: user.id, user: { user_name: new_user.displayname } }
    expect(response).to redirect_to(new_user)
  end
  it 'business_roles_move_to' do
    business_role = create :business_role, bproce_id: bproce.id
    user_business_role = create :user_business_role, business_role_id: business_role.id, user_id: user.id
    new_user = FactoryBot.create :user
    post :business_roles_move_to, params: { id: user.id, user: { user_name: new_user.displayname } }
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
  it 'render contracts' do
    get :contracts, params: { id: user.id }
    expect(response).to render_template :contracts
  end
  it 'render resources' do
    get :resources, params: { id: user.id }
    expect(response).to render_template :resources
  end
  it 'render processes' do
    get :processes, params: { id: user.id }
    expect(response).to render_template :processes
  end

  it 'render execute' do
    get :execute, params: { id: user.id }
    expect(response).to render_template :execute
  end

  describe 'reports' do
    it 'render order' do
      business_role = create :business_role, bproce_id: bproce.id
      user_business_role = create :user_business_role, business_role_id: business_role.id, user_id: user.id
      get :order, params: { id: user.to_param }
      expect(response).to be_successful
    end
    it 'generate pass' do
      get :pass, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end
end
