# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectivesController do
  # let(:valid_attributes) { FactoryGirl.create :directive }
  let(:valid_attributes) do
    { approval: '01.01.2013',
      number: '100',
      name: 'directive_name',
      body: 'test' }
  end
  let(:valid_session) { { 'warden.user.user.key' => session['warden.user.user.key'] } }

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all directives as @directives' do
      directive = Directive.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it 'loads all of the directives into @directives' do
      directive1 = FactoryGirl.create(:directive)
      directive2 = FactoryGirl.create(:directive)
      get :index
      expect(assigns(:directives)).to match_array([directive1, directive2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested directive as @directive' do
      @bproce = FactoryGirl.create(:bproce)
      directive = Directive.create! valid_attributes
      get :show, { id: directive.to_param }, valid_session
      expect(assigns(:directive)).to eq(directive)
    end
  end

  describe 'GET new' do
    it 'assigns a new directive as @directive' do
      get :new, {}, valid_session
      expect(assigns(:directive)).to be_a_new(Directive)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested directive as @directive' do
      directive = Directive.create! valid_attributes
      get :edit, { id: directive.to_param }, valid_session
      expect(assigns(:directive)).to eq(directive)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Directive' do
        expect do
          post :create, { directive: valid_attributes }, valid_session
        end.to change(Directive, :count).by(1)
      end

      it 'assigns a newly created directive as @directive' do
        post :create, { directive: valid_attributes }, valid_session
        expect(assigns(:directive)).to be_a(Directive)
        expect(assigns(:directive)).to be_persisted
      end

      it 'redirects to the created directive' do
        post :create, { directive: valid_attributes }, valid_session
        expect(response).to redirect_to(Directive.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved directive as @directive' do
        expect_any_instance_of(Directive).to receive(:save).and_return(false)
        post :create, { directive: {} }, valid_session
        expect(assigns(:directive)).to be_a_new(Directive)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Directive).to receive(:save).and_return(false)
        post :create, { directive: {} }, valid_session
        expect(response).to_not render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested directive' do
        directive = Directive.create! valid_attributes
        expect_any_instance_of(Directive).to receive(:save).and_return(false)
        put :update, { id: directive.to_param, directive: { 'these' => 'params' } }, valid_session
      end

      it 'assigns the requested directive as @directive' do
        directive = Directive.create! valid_attributes
        put :update, { id: directive.to_param, directive: valid_attributes }, valid_session
        expect(assigns(:directive)).to eq(directive)
      end

      it 'redirects to the directive' do
        directive = Directive.create! valid_attributes
        put :update, { id: directive.to_param, directive: valid_attributes }, valid_session
        expect(response).to redirect_to(directive)
      end
    end

    describe 'with invalid params' do
      it 'assigns the directive as @directive' do
        directive = Directive.create! valid_attributes
        expect_any_instance_of(Directive).to receive(:save).and_return(false)
        put :update, { id: directive.to_param, directive: {} }, valid_session
        expect(assigns(:directive)).to eq(directive)
      end

      it "re-renders the 'edit' template" do
        directive = Directive.create! valid_attributes
        expect_any_instance_of(Directive).to receive(:save).and_return(false)
        put :update, { id: directive.to_param, directive: {} }, valid_session
        expect(response).to_not render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested directive' do
      directive = Directive.create! valid_attributes
      expect do
        delete :destroy, { id: directive.to_param }, valid_session
      end.to change(Directive, :count).by(-1)
    end

    it 'redirects to the directives list' do
      directive = Directive.create! valid_attributes
      delete :destroy, { id: directive.to_param }, valid_session
      expect(response).to redirect_to(directives_url)
    end
  end
end
