# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DocumentDirectivesController, type: :controller do
  let(:owner)            { FactoryGirl.create(:user) }
  let(:role)             { FactoryGirl.create(:role, name: 'author', description: 'Автор' ) }
  let!(:document)        { create(:document, owner: owner)}
  let!(:directive)       { create(:directive)}
  let(:valid_document_directive)  { FactoryGirl.create(:document_directive,
                                                              document: document,
                                                              directive: FactoryGirl.create(:directive)) }
  let(:valid_document_directives)  { 2.times FactoryGirl.create(:document_directive,
                                                              document: document,
                                                              directive: FactoryGirl.create(:directive)) }
  let(:invalid_document_directive) { FactoryGirl.create(:document_directive, :invalid) }

  describe 'GET index' do
    it 'assigns all document_directives as @document_directives' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('document_directives/index')
    end

    it 'loads all of the document_directives into @document_directives' do
      document_directives = valid_document_directives
      get :index
      expect(assigns(:document_directives)).to match_array(document_directives)
    end
  end

  describe 'GET show' do
    it 'assigns the requested document_directive as @document_directive' do
      document_directive = valid_document_directive
      get :show, { id: document_directive.to_param }
      expect(assigns(:document_directive)).to eq(document_directive)
    end
  end

  context 'with mocked authentication' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    describe 'GET new' do
      it 'assigns a new document_directive as @document_directive' do
        get :new
        expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested document_directive as @document_directive' do
        document_directive = valid_document_directives.first
        get :edit, { id: document_directive.to_param }
        expect(assigns(:document_directive)).to eq(document_directive)
      end
    end

    describe 'POST create' do
      let(:document_directive) { build(:document_directive) }
      before { sign_in(owner) } # для создания документа юзер должен быть авторизован

      describe 'with valid params' do
        it 'creates a new DocumentDirective' do
          expect do
            post :create, { document_directive: document_directive.as_json }
          end.to change(DocumentDirective, :count).by(1)
        end

        it 'assigns a newly created document_directive as @document_directive' do
          post :create, { document_directive: valid_document_directive.as_json }
          expect(assigns(:document_directive)).to be_a(DocumentDirective)
          expect(assigns(:document_directive)).to be_persisted
        end

        it 'redirects to the created document_directive' do
          post :create, { document_directive: document_directive.as_json }
          expect(response).to redirect_to(DocumentDirective.last)
        end
      end

      describe 'with invalid params' do
        let(:invalid_document_directive) {build(:document_directive, :invalid)}
        it 'assigns a newly created but unsaved document_directive as @document_directive' do
          post :create, { document_directive: invalid_document_directive.as_json }
          expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
        end

        it "re-renders the 'new' template" do
          post :create, { document_directive: invalid_document_directive.as_json }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested document_directive' do
          document_directive = valid_document_directive
          document_directive.note = 'New valid name'
          put :update, { id: document_directive.id, document_directive: document_directive.as_json }
          expect(document_directive.reload.note).to eq 'New valid name'
        end

        it 'assigns the requested document_directive as @document_directive' do
          document_directive = valid_document_directive
          put :update, { id: document_directive.to_param, document_directive: document_directive.as_json }
          expect(assigns(:document_directive)).to eq(document_directive)
        end

        it 'redirects to the document_directive' do
          document_directive = valid_document_directive
          put :update, { id: document_directive.to_param, document_directive: document_directive.as_json }
          expect(response).to redirect_to(document_directive)
        end
      end

      describe 'with invalid params' do
        it 'assigns the document_directive as @document_directive' do
          document_directive = valid_document_directive
          document_directive.note = '' #  not valid
          put :update, { id: document_directive.id, document_directive: document_directive.as_json }
          expect(assigns(:document_directive)).to eq(document_directive)
        end

        it "re-renders the 'edit' template" do
          document_directive = valid_document_directive
          document_directive.note = '' #  not valid
          put :update, { id: document_directive.id, document_directive: document_directive.as_json }
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested document_directive' do
      document_directive = valid_document_directive
      expect do
        delete :destroy, { id: document_directive.id }
      end.to change(DocumentDirective, :count).by(-1)
    end

    it 'redirects to the document_directives list' do
      document_directive = valid_document_directive
      delete :destroy, { id: document_directive.id }
      expect(response).to redirect_to(document_directives_url)
    end
  end
end
