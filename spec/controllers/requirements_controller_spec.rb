# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequirementsController, type: :controller do
  let(:author)           { FactoryBot.create(:user) }
  let(:valid_attributes) { { label: 'requirement', author_id: author.id } }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
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
      requirement1 = FactoryBot.create(:requirement, label: 'requirement1', author_id: author.id)
      requirement2 = FactoryBot.create(:requirement, label: 'requirement2', author_id: author.id)
      get :index
      expect(assigns(:requirements)).to match_array([requirement1, requirement2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested requirement as @requirement' do
      requirement = Requirement.create! valid_attributes
      get :show, params: { id: requirement.to_param }
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
        post :create, params: { requirement: valid_attributes }
        expect(response).to redirect_to(Requirement.last)
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
end
