# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:author) { FactoryBot.create :user }
  let(:task_attributes) { { name: 'Task0', description: 'description', status: 0, duedate: Date.current + 1, author_id: author.id } }
  let!(:task) { FactoryBot.create :task, author_id: author.id }
  let!(:task1) { FactoryBot.create :task, author_id: author.id }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all task as @tasks' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('tasks/index')
    end

    it 'loads all of the tasks into @tasks' do
      get :index
      expect(assigns(:tasks)).to match_array([task, task1])
    end

    it 'load tasks with status' do
      user = create :user
      task50 = FactoryBot.create :task, author_id: user.id, status: 50
      user_task = FactoryBot.create :user_task, user_id: user.id, task_id: task50.id
      task50.status = 50
      task50.save
      get :index, params: { status: '50' }
      # expect(assigns(:tasks)).to match_array([task50])
    end
    it 'load tasks for user' do
      user = create :user
      task_u = FactoryBot.create :task, author_id: user.id
      user_task = create :user_task, user_id: user.id, task_id: task_u.id
      get :index, params: { user: user.id }
      expect(assigns(:tasks)).to match_array([task_u])
    end
  end

  describe 'GET show' do
    it 'assigns the requested task as @task' do
      get :show, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'GET new' do
    it 'assigns a new task as @task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
    it 'assigns a new task from letter' do
      letter = FactoryBot.create :letter
      get :new, params: { letter_id: letter.id }
      expect(assigns(:task)).to be_a_new(Task)
    end
    it 'assigns a new task from requirement' do
      requirement = FactoryBot.create :requirement, author_id: author.id
      get :new, params: { requirement_id: requirement.id }
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Task' do
        expect do
          post :create, params: { task: task_attributes }
        end.to change(Task, :count).by(1)
      end

      it 'assigns a newly created task as @task' do
        post :create, params: { task: task_attributes }
        expect(assigns(:task)).to be_a(Task)
        expect(assigns(:task)).to be_persisted
      end

      it 'redirects to the created task' do
        post :create, params: { task: task_attributes }
        new_task = Task.where(name: 'Task0').first
        expect(response).to redirect_to(new_task)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved task as @task' do
        expect_any_instance_of(Task).to receive(:save).and_return(false)
        post :create, params: { task: { 'name' => 'invalid value' } }
        expect(assigns(:task)).to be_a_new(Task)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Task).to receive(:save).and_return(false)
        post :create, params: { task: { 'name' => 'invalid value' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET edit' do
    it 'assigns the requested task as @task' do
      task = Task.create! task_attributes
      get :edit, params: { id: task.to_param }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested task' do
        task = Task.create! task_attributes
        expect_any_instance_of(Task).to receive(:save).at_least(:once)
        put :update, params: { id: task.to_param, task: { 'name' => 'MyString' } }
      end

      it 'assigns the requested task as @task' do
        task = Task.create! task_attributes
        put :update, params: { id: task.to_param, task: task_attributes }
        expect(assigns(:task)).to eq(task)
      end

      it 'redirects to the task' do
        task = Task.create! task_attributes
        put :update, params: { id: task.to_param, task: task_attributes }
        expect(response).to redirect_to(task)
      end
    end

    describe 'with invalid params' do
      it 'assigns the task as @task' do
        task = Task.create! task_attributes
        expect_any_instance_of(Task).to receive(:save).and_return(false)
        put :update, params: { id: task.to_param, task: { 'name' => 'invalid value' } }
        expect(assigns(:task)).to eq(task)
      end

      it "re-renders the 'edit' template" do
        task = Task.create! task_attributes
        expect_any_instance_of(Task).to receive(:save).and_return(false)
        put :update, params: { id: task.to_param, task: { 'name' => 'invalid value' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested task' do
      task = Task.create! task_attributes
      expect do
        delete :destroy, params: { id: task.to_param }
      end.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      task = Task.create! task_attributes
      delete :destroy, params: { id: task.to_param }
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe 'update_user' do
    it 'save user and show task' do
      user = create :user
      user_task = create :user_task, user_id: user.id, task_id: task.id
      put :update_user, params: { id: task.to_param, 
          user_task: { user_id: user.id, task_id: task.id, status: 0, user_name: user.displayname } }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'create_user' do
    it 'render create_user' do
      # get :create_user, params: { id: task.to_param }
      # expect(response).to render_template(partial: 'show')
    end
  end
end
