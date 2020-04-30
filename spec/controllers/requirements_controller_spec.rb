# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequirementsController do
  let(:author) { create(:user) }
  let(:requirement) { create :requirement, author: author }
  let(:requirement_created) { { label: 'label_created', author_id: author.id, status: 5 } }
  let(:valid_attributes) { { label: requirement.label, author_id: author.id, status: 5 } }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }

  let(:letter) { create :letter, author: author }
  let!(:task) { create :task, author: author, requirement: requirement }
  let(:user) { create :user }
  let!(:user_requirement) { create :user_requirement, requirement: requirement, user: user }
  let(:current_user) { create :user }

  before do
    @user = author
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    @user.roles << Role.find_or_create_by(name: 'user`', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all requirements as @requirements' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('requirements/index')
    end

    it 'loads all of the requirements into @requirements' do
      requirement1 = create(:requirement, label: 'RequirementNew', author_id: author.id)
      get :index
      expect(assigns(:requirements)).to match_array([requirement, requirement1])
    end

    it 'show requirement with status' do
      requirement_with_status = FactoryBot.create :requirement, author: author, status: 5
      get :index, params: { status: '5' }
      expect(assigns(:requirements)).to match_array([requirement_with_status])
    end
  end

  describe 'GET show' do
    it 'assigns the requested requirement as @requirement' do
      puts requirement.inspect
      puts requirement.to_param
      get :show, params: { id: requirement.to_param }
      expect(assigns(:requirement)).to eq(requirement)
    end

    it 'show with :sort' do
      get :show, params: { id: requirement.to_param, sort: 'id' }
      expect(assigns(:requirement)).to eq(requirement)
    end
  end

  describe 'GET new' do
    it 'assigns a new requirement as @requirement' do
      get :new
      expect(assigns(:requirement)).to be_a_new(Requirement)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested requirement as @requirement' do
      requirement = Requirement.create! valid_attributes
      get :edit, params: { id: requirement.to_param }
      expect(assigns(:requirement)).to eq(requirement)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Requirement' do
        expect do
          post :create, params: { requirement: valid_attributes }
        end.to change(Requirement, :count).by(1)
      end

      it 'assigns a newly created requirement as @requirement' do
        post :create, params: { requirement: valid_attributes }
        expect(assigns(:requirement)).to be_a(Requirement)
        expect(assigns(:requirement)).to be_persisted
      end

      it 'redirects to the created requirement' do
        post :create, params: { requirement: requirement_created }
        requirement = Requirement.where(label: 'label_created').first
        expect(response).to redirect_to requirement_path(requirement.id)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved requirement as @requirement' do
        post :create, params: { requirement: invalid_attributes }
        expect(assigns(:requirement)).to be_a_new(Requirement)
      end

      it "re-renders the 'new' template" do
        post :create, params: { requirement: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested requirement' do
        requirement = Requirement.create! valid_attributes
        expect_any_instance_of(Requirement).to receive(:save).at_least(:once)
        put :update, params: { id: requirement.to_param, requirement: valid_attributes }
      end

      it 'assigns the requested requirement as @requirement' do
        requirement = Requirement.create! valid_attributes
        put :update, params: { id: requirement.to_param, requirement: valid_attributes }
        expect(assigns(:requirement)).to eq(requirement)
      end

      it 'redirects to the requirement' do
        requirement = Requirement.create! valid_attributes
        put :update, params: { id: requirement.to_param, requirement: valid_attributes }
        expect(response).to redirect_to(requirement)
      end
    end

    describe 'with invalid params' do
      it 'assigns the requirement as @requirement' do
        requirement = Requirement.create! valid_attributes
        expect_any_instance_of(Requirement).to receive(:save).and_return(false)
        put :update, params: { id: requirement.to_param, requirement: invalid_attributes }
        expect(assigns(:requirement)).to eq(requirement)
      end

      it "re-renders the 'edit' template" do
        requirement = Requirement.create! valid_attributes
        expect_any_instance_of(Requirement).to receive(:save).and_return(false)
        put :update, params: { id: requirement.to_param, requirement: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested requirement' do
      requirement = Requirement.create! valid_attributes
      expect do
        delete :destroy, params: { id: requirement.to_param }
      end.to change(Requirement, :count).by(-1)
    end

    it 'redirects to the requirements list' do
      requirement = Requirement.create! valid_attributes
      delete :destroy, params: { id: requirement.to_param }
      expect(response).to redirect_to(requirements_url)
    end
  end

  describe 'update_user' do
    it 'save user and show requirement' do
      user = create :user
      user_requirement = create :user_requirement, user_id: user.id, requirement_id: requirement.id
      put :update_user, params: { id: requirement.to_param,
                                  user_requirement: { user_id: user.id,
                                                      requirement_id: requirement.id, status: 0, user_name: user.displayname } }
      expect(assigns(:requirement)).to eq(requirement)
    end
  end

  describe 'reports' do
    let(:user) { create :user }
    let!(:user_task) { create :user_task, task: task, user: user, status: 1 }
    let(:requirement_with_letter) { create :requirement, author: author, letter: letter }

    it 'tasks_list' do
      get :tasks_list, params: { id: requirement.to_param }
      expect(response).to be_successful
    end

    it 'tasks_report' do
      get :tasks_report, params: { id: requirement.to_param }
      expect(response).to be_successful
    end

    it 'tasks_list requirement_with_letter' do
      get :tasks_list, params: { id: requirement_with_letter.to_param }
      expect(response).to be_successful
    end

    it 'tasks_report requirement_with_letter' do
      get :tasks_report, params: { id: requirement_with_letter.to_param }
      expect(response).to be_successful
    end
  end
end
