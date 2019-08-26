# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserTasksController, type: :controller do
  let(:user)             { FactoryBot.create(:user) }
  let(:author)           { FactoryBot.create(:user) }
  let!(:task)            { FactoryBot.create(:task, author_id: author.id) }
  let(:user_task)        { FactoryBot.create(:user_task, user_id: user.id, task_id: task.id) }
  let(:valid_attributes) { { user_id: user.id, task_id: task.id, status: 0 } }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested user_task as @user_task' do
      get :show, params: { id: user_task.id.to_param }
      expect(assigns(:user_task)).to eq(user_task)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new UserTask' do
        expect do
          post :create, params: { user_task: valid_attributes }
        end.to change(UserTask, :count).by(1)
      end

      it 'assigns a newly created user_task as @user_task' do
        post :create, params: { user_task: valid_attributes }
        expect(assigns(:user_task)).to be_a(UserTask)
        expect(assigns(:user_task)).to be_persisted
      end

      it 'redirects to the created user_task' do
        post :create, params: { user_task: valid_attributes }
        expect(response).to redirect_to(UserTask.last)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested user_task' do
      user_task = UserTask.create! valid_attributes
      expect do
        delete :destroy, params: { id: user_task.to_param }
      end.to change(UserTask, :count).by(-1)
    end
  end
end
