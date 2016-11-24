# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:owner) { { username: 'name', email: 'person#{id}@example.com' } }
  let(:valid_attributes) { { name: 'document name', place: 'place', dlevel: 3, owner: owner } }
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all documents as @documents' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('documents/index')
    end

    it 'loads all of the documents into @documents' do
      document1 = Document.create! valid_attributes
      document2 = Document.create! valid_attributes
      get :index
      expect(assigns(:documents)).to match_array([document1, document2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested document as @document' do
      document = Document.create! valid_attributes
      get :show, { id: document.to_param }, valid_session
      expect(assigns(:document)).to eq(document)
    end
  end

  describe 'GET new' do
    it 'assigns a new document as @document' do
      get :new, valid_session
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested document as @document' do
      document = Document.create! valid_attributes
      get :edit, { id: document.to_param }, valid_session
      expect(assigns(:document)).to eq(document)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Document' do
        expect do
          post :create, { document: valid_attributes }, valid_session
        end.to change(Document, :count).by(1)
      end

      it 'assigns a newly created document as @document' do
        post :create, { document: valid_attributes }, valid_session
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it 'redirects to the created document' do
        post :create, { document: valid_attributes }, valid_session
        expect(response).to redirect_to(Document.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved document as @document' do
        post :create, { document: invalid_attributes }, valid_session
        expect(assigns(:document)).to be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        post :create, { document: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested document' do
        document = Document.create! valid_attributes
        expect_any_instance_of(Document).to receive(:save).at_least(:once)
        put :update, { id: document.to_param, document: valid_attributes }, valid_session
      end

      it 'assigns the requested document as @document' do
        document = Document.create! valid_attributes
        put :update, { id: document.to_param, document: valid_attributes }, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it 'redirects to the document' do
        document = Document.create! valid_attributes
        put :update, { id: document.to_param, document: valid_attributes }, valid_session
        expect(response).to redirect_to(document)
      end
    end

    describe 'with invalid params' do
      it 'assigns the document as @document' do
        document = Document.create! valid_attributes
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        put :update, { id: document.to_param, document: invalid_attributes }, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Document.create! valid_attributes
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        put :update, { id: document.to_param, document: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested document' do
      document = Document.create! valid_attributes
      expect do
        delete :destroy, { id: document.to_param }, valid_session
      end.to change(Document, :count).by(-1)
    end

    it 'redirects to the documents list' do
      document = Document.create! valid_attributes
      delete :destroy, { id: document.to_param }, valid_session
      expect(response).to redirect_to(documents_url)
    end
  end
end
