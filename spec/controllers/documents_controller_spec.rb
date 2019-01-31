# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:owner)              { FactoryBot.create(:user) }
  let(:role)               { FactoryBot.create(:role, name: 'author', description: 'Автор') }
  let(:invalid_document)   { FactoryBot.create(:document, :invalid) }
  let(:document)           { FactoryBot.create(:document, owner: owner) }
  let!(:doc2)              { FactoryBot.create(:document, owner: owner) }
  let!(:bproce)            { FactoryBot.create(:bproce, user_id: owner.id) }
  let!(:bproce_document)   { BproceDocument.create(bproce_id: bproce.id, document_id: doc2.id, purpose: 'two') }
  let!(:bproce_document)   { BproceDocument.create(bproce_id: bproce.id, document_id: document.id, purpose: 'one') }

  describe 'GET index' do
    it 'assigns all documents as @documents' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('documents/index')
    end

    it 'loads all of the documents into @documents' do
      get :index
      expect(assigns(:documents)).to match_array([document, doc2])
    end
    it 'returns documents for bproce if param bproce_id present' do
      get :index, params: { bproce_id: bproce.id }
      expect(assigns(:documents)).to match_array([document])
    end
  end

  describe 'GET show' do
    it 'assigns the requested document as @document' do
      get :show, params: { id: document.to_param }
      expect(assigns(:document)).to eq(document)
    end
  end

  context 'with mocked authentication' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    describe 'GET new' do
      it 'assigns a new document as @document' do
        get :new
        expect(assigns(:document)).to be_a_new(Document)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested document as @document' do
        get :edit, params: { id: document.to_param }
        expect(assigns(:document)).to eq(document)
      end
    end

    describe 'POST create' do
      let(:document) { build(:document) }

      before { sign_in(owner) } # для создания документа юзер должен быть авторизован

      describe 'with valid params' do
        it 'creates a new Document' do
          expect do
            post :create, params: { document: document.as_json }
          end.to change(Document, :count).by(1)
        end

        it 'assigns a newly created document as @document' do
          post :create, params: { document: document.as_json }
          expect(assigns(:document)).to be_a(Document)
          expect(assigns(:document)).to be_persisted
        end

        it 'redirects to the created document' do
          post :create, params: { document: document.as_json }
          expect(response).to redirect_to(Document.last)
        end
      end

      describe 'with invalid params' do
        let(:invalid_document) { build(:document, :invalid) }

        it 'assigns a newly created but unsaved document as @document' do
          post :create, params: { document: invalid_document.as_json }
          expect(assigns(:document)).to be_a_new(Document)
        end

        it "re-renders the 'new' template" do
          post :create, params: { document: invalid_document.as_json }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested document' do
          document.name = 'New valid name'
          put :update, params: { id: document.id, document: document.as_json }
          expect(document.reload.name).to eq 'New valid name'
        end

        it 'assigns the requested document as @document' do
          put :update, params: { id: document.to_param, document: document.as_json }
          expect(assigns(:document)).to eq(document)
        end

        it 'redirects to the document' do
          put :update, params: { id: document.to_param, document: document.as_json }
          expect(response).to redirect_to(document)
        end
      end

      describe 'with invalid params' do
        it 'assigns the document as @document' do
          document.name = '' #  not valid
          put :update, params: { id: document.id, document: document.as_json }
          expect(assigns(:document)).to eq(document)
        end

        it "re-renders the 'edit' template" do
          document.name = '' #  not valid
          put :update, params: { id: document.id, document: document.as_json }
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested document' do
      expect do
        delete :destroy, params: { id: document.id }
      end.to change(Document, :count).by(-1)
    end

    it 'redirects to the documents list' do
      delete :destroy, params: { id: document.id }
      expect(response).to redirect_to(documents_url)
    end
  end
end
