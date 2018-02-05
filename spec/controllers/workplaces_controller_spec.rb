# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkplacesController, type: :controller do
  let(:valid_attributes) { { name: 'workplace', description: 'workplace description', designation: 'workplace designation' } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all workplaces as @workplaces' do
      get :index, {}
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('workplaces/index')
    end

    it 'loads all of the workplaces into @workplaces' do
      workplace1 = FactoryBot.create(:workplace)
      workplace2 = FactoryBot.create(:workplace)
      get :index
      expect(assigns(:workplaces)).to match_array([workplace1, workplace2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested workplace as @workplace' do
      workplace = FactoryBot.create(:workplace)
      get :show, params: { id: workplace.id }
      expect(assigns(:workplace)).to eq(workplace)
    end
  end

  describe 'GET new' do
    it 'assigns a new workplace as @workplace' do
      get :new
      expect(assigns(:workplace)).to be_a_new(Workplace)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested workplace as @workplace' do
      workplace = FactoryBot.create(:workplace)
      get :edit, params: { id: workplace.id }
      expect(assigns(:workplace)).to eq(workplace)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Workplace' do
        expect do
          post :create, params: { workplace: valid_attributes }
        end.to change(Workplace, :count).by(1)
      end

      it 'assigns a newly created workplace as @workplace' do
        post :create, params: { workplace: valid_attributes }
        expect(assigns(:workplace)).to be_a(Workplace)
        expect(assigns(:workplace)).to be_persisted
      end

      it 'redirects to the created workplace' do
        post :create, params: { workplace: valid_attributes }
        expect(response).to redirect_to(Workplace.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved workplace as @workplace' do
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        post :create, params: { workplace: { name: 'invalid name' } }
        expect(assigns(:workplace)).to be_a_new(Workplace)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        post :create, params: { workplace: { name: 'invalid name' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested workplace' do
        workplace = FactoryBot.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).at_least(:once)
        put :update, params: { id: workplace.to_param, workplace: { 'name' => 'test_name' } }
      end

      it 'assigns the requested workplace as @workplace' do
        workplace = FactoryBot.create(:workplace)
        put :update, params: { id: workplace.id, workplace: valid_attributes }
        expect(assigns(:workplace)).to eq(workplace)
      end

      it 'redirects to the workplace' do
        workplace = FactoryBot.create(:workplace)
        put :update, params: { id: workplace.id, workplace: valid_attributes }
        expect(response).to redirect_to(workplace)
      end
    end

    describe 'with invalid params' do
      it 'assigns the workplace as @workplace' do
        workplace = FactoryBot.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        put :update, params: { id: workplace.to_param, workplace: { 'name' => 'invalid value' } }
        expect(assigns(:workplace)).to eq(workplace)
      end

      it "re-renders the 'edit' template" do
        workplace = FactoryBot.create(:workplace)
        expect_any_instance_of(Workplace).to receive(:save).and_return(false)
        put :update, params: { id: workplace.to_param, workplace: { 'name' => 'invalid value' } }
        expect(response).to_not render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested workplace' do
      workplace = FactoryBot.create(:workplace)
      expect do
        delete :destroy, params: { id: workplace.id }
      end.to change(Workplace, :count).by(-1)
    end

    it 'redirects to the workplaces list' do
      workplace = FactoryBot.create(:workplace)
      delete :destroy, params: { id: workplace.id }
      expect(response).to redirect_to(workplaces_url)
    end
  end
end
