# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentDirectivesController, type: :controller do
  let(:owner)            { FactoryGirl.create(:user) }
  let(:role)             { FactoryGirl.create(:role, name: 'author', description: 'Автор') }
  let!(:bproce)          { FactoryGirl.create(:bproce) }
  let!(:document)        { FactoryGirl.create(:document, owner: owner) }
  let!(:directive)       { FactoryGirl.create(:directive) }
  let(:document_directive) { FactoryGirl.create(:document_directive, document_id: document.id) }
  let(:valid_attributes) { { directive_id: directive.id, document_id: document.id } }
  let(:invalid_attributes) { { directive_id: nil, document_id: document.id } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #index' do
    it 'populates an array of document_directives' do
      get :index
      expect(assigns(:document_directives)).to eq([document_directive])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested contact to @document_directive' do
      get :show, id: document_directive
      expect(assigns(:document_directive)).to eq(document_directive)
    end

    it 'renders the #show view' do
      get :show, id: document_directive
      # expect(response).to render_template(:show)
      expect(subject).to redirect_to(directive_url(document_directive.directive.id))
    end
  end

  describe 'GET new' do
    it 'assigns a new document_directive as @document_directive' do
      get :new
      expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested document_directive as @document_directive' do
      get :edit, id: document_directive.to_param
      expect(assigns(:document_directive)).to eq(document_directive)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new DocumentDirective' do
        expect do
          post :create, { document_directive: valid_attributes }, valid_session
        end.to change(DocumentDirective, :count).by(1)
      end

      it 'assigns a newly created document_directive as @document_directive' do
        post :create, { document_directive: valid_attributes }, valid_session
        expect(assigns(:document_directive)).to be_a(DocumentDirective)
        expect(assigns(:document_directive)).to be_persisted
      end

      it 'redirects to the created document_directive' do
        post :create, { document_directive: valid_attributes }, valid_session
        expect(response).to redirect_to(DocumentDirective.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved document_directive as @document_directive' do
        post :create, { document_directive: invalid_attributes }, valid_session
        expect(assigns(:document_directive)).to be_a_new(DocumentDirective)
      end

      it "re-renders the 'new' template" do
        post :create, { document_directive: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested document_directive' do
          put :update, { document_directive: invalid_attributes }, valid_session
          expect(document_directive.reload.note).to eq 'New valid name'
        end

        it 'assigns the requested document_directive as @document_directive' do
          put :update, { document_directive: invalid_attributes }, valid_session
          expect(assigns(:document_directive)).to eq(document_directive)
        end

        it 'redirects to the document_directive' do
          put :update, { document_directive: invalid_attributes }, valid_session
          expect(response).to redirect_to(document_directive)
        end
      end

      describe 'with invalid params' do
        it 'assigns the document_directive as @document_directive' do
          document_directive = valid_document_directive
          document_directive.note = '' #  not valid
          put :update, id: document_directive.id, document_directive: document_directive.as_json
          expect(assigns(:document_directive)).to eq(document_directive)
        end

        it "re-renders the 'edit' template" do
          document_directive = valid_document_directive
          document_directive.note = '' #  not valid
          put :update, id: document_directive.id, document_directive: document_directive.as_json
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested document_directive' do
      document1 = FactoryGirl.create(:document, owner: owner)
      document_directive = FactoryGirl.create(:document_directive, document_id: document1.id)
      expect do
        delete :destroy, id: document_directive.id
      end.to change(DocumentDirective, :count).by(-1)
      expect(flash[:notice]).to be_present
    end

    it 'redirects to the document_directives list' do
      document1 = FactoryGirl.create(:document, owner: owner)
      document_directive = FactoryGirl.create(:document_directive, document_id: document1.id)
      delete :destroy, id: document_directive.id
      expect(response).to redirect_to(document_url(document1))
    end
  end
end
