# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BproceDocumentsController, type: :controller do
  let(:owner)            { FactoryBot.create(:user) }
  let(:role)             { FactoryBot.create(:role, name: 'author', description: 'Автор') }
  let!(:bproce)          { FactoryBot.create(:bproce) }
  let!(:bproce2)         { FactoryBot.create(:bproce) }
  let!(:document)        { FactoryBot.create(:document, owner: owner) }
  let(:bproce_document)  { FactoryBot.create(:bproce_document, bproce_id: bproce.id, document_id: document.id) }
  let(:valid_attributes) { { bproce_id: bproce.id, document_id: document.id } }
  let(:invalid_attributes) { { bproce_id: nil, document_id: document.id } }

  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested bproce_document as @bproce_document' do
      get :show, { id: bproce_document.to_param }, valid_session
      expect(assigns(:bproce_document)).to eq(bproce_document)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce_document as @bproce_document' do
      get :edit, { id: bproce_document.to_param }, valid_session
      expect(assigns(:bproce_document)).to eq(bproce_document)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceDocument' do
        expect do
          post :create, { bproce_document: valid_attributes }, valid_session
        end.to change(BproceDocument, :count).by(1)
      end

      it 'assigns a newly created bproce_document as @bproce_document' do
        post :create, { bproce_document: valid_attributes }, valid_session
        expect(assigns(:bproce_document)).to be_a(BproceDocument)
        expect(assigns(:bproce_document)).to be_persisted
      end

      it 'redirects to the created bproce_document' do
        post :create, { bproce_document: valid_attributes }, valid_session
        expect(response).to redirect_to(BproceDocument.last.document)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce_document as @bproce_document' do
        expect_any_instance_of(BproceDocument).to receive(:save).and_return(false)
        post :create, { bproce_document: invalid_attributes }, valid_session
        expect(assigns(:bproce_document)).to be_a_new(BproceDocument)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce_document' do
        expect_any_instance_of(BproceDocument).to receive(:save).and_return(false)
        put :update, { id: bproce_document.to_param, bproce_document: { 'these' => 'params' } }, valid_session
      end

      it 'assigns the requested bproce_document as @bproce_document' do
        put :update, { id: bproce_document.to_param, bproce_document: valid_attributes }, valid_session
        expect(assigns(:bproce_document)).to eq(bproce_document)
      end

      it 'redirects to the bproce_document' do
        put :update, { id: bproce_document.to_param, bproce_document: valid_attributes }, valid_session
        expect(response).to redirect_to(bproce_document)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce_document as @bproce_document' do
        expect_any_instance_of(BproceDocument).to receive(:save).and_return(false)
        put :update, { id: bproce_document.to_param, bproce_document: {} }, valid_session
        expect(assigns(:bproce_document)).to eq(bproce_document)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(BproceDocument).to receive(:save).and_return(false)
        put :update, { id: bproce_document.to_param, bproce_id: bproce.to_param, document_id: document.to_param }, valid_session
        expect(response).to redirect_to bproce_document # render_template("edit")
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce_document as @bproce_document' do
        expect_any_instance_of(BproceDocument).to receive(:save).and_return(false)
        put :update, { id: bproce_document.to_param, bproce_document: {} }, valid_session
        expect(assigns(:bproce_document)).to eq(bproce_document)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys bproce_document if it has > 1 bproce' do
      # документ должен ссылаться хотя бы на 1 процесс
      bproce1 = FactoryBot.create(:bproce)
      bproce_document1 = FactoryBot.create(:bproce_document, bproce_id: bproce1.id, document_id: document.id)
      bproce_document2 = FactoryBot.create(:bproce_document, bproce_id: bproce2.id, document_id: document.id)
      expect do
        delete :destroy, id: bproce_document2.id
      end.to change(BproceDocument, :count).by(-1)
      expect(flash[:notice]).to be_present
    end

    it 'do not destroys bproce_document if it has 1 bproce' do
      # документ должен ссылаться хотя бы на 1 процесс
      bproce_document2 = FactoryBot.create(:bproce_document, bproce_id: bproce2.id, document_id: document.id)
      expect do
        delete :destroy, id: bproce_document2.id
      end.to change(BproceDocument, :count).by(0)
      expect(flash[:alert]).to be_present
    end

    it 'redirects to the bproce_documents list' do
      delete :destroy, { id: bproce_document.to_param }, valid_session
      expect(response).to redirect_to document_url
    end
  end
end
