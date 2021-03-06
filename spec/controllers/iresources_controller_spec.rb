# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IresourcesController, type: :controller do
  let(:user)              { create :user }
  let(:valid_iresources)  { create_list :iresource, 2 }
  let(:invalid_iresource) { create :iresource, :invalid }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all iresources as @iresources' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('iresources/index')
    end

    it 'loads all of the iresources into @iresources' do
      iresources = valid_iresources
      get :index
      expect(assigns(:iresources)).to match_array(iresources)
    end

    it 'loads letter for user' do
      user = create :user
      iresource_user = create :iresource, user_id: user.id
      get :index, params: { user: user.id }
      expect(assigns(:iresources)).to match_array([iresource_user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested iresource as @iresource' do
      iresource = valid_iresources.first
      get :show, params: { id: iresource.to_param }
      expect(assigns(:iresource)).to eq(iresource)
    end
  end

  context 'with mocked authentication' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    describe 'GET new' do
      it 'assigns a new iresource as @iresource' do
        get :new
        expect(assigns(:iresource)).to be_a_new(Iresource)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested iresource as @iresource' do
        iresource = valid_iresources.first
        get :edit, params: { id: iresource.to_param }
        expect(assigns(:iresource)).to eq(iresource)
      end
    end

    describe 'POST create' do
      let(:iresource) { build(:iresource) }

      before { sign_in(user) }

      describe 'with valid params' do
        it 'creates a new Iresource' do
          expect do
            post :create, params: { iresource: iresource.as_json }
          end.to change(Iresource, :count).by(1)
        end

        it 'assigns a newly created iresource as @iresource' do
          post :create, params: { iresource: iresource.as_json }
          expect(assigns(:iresource)).to be_a(Iresource)
          expect(assigns(:iresource)).to be_persisted
        end

        it 'redirects to the created iresource' do
          post :create, params: { iresource: iresource.as_json }
          expect(response).to redirect_to(Iresource.last)
        end
      end

      describe 'with invalid params' do
        let(:invalid_iresource) { build(:iresource, :invalid) }

        it 'assigns a newly created but unsaved iresource as @iresource' do
          post :create, params: { iresource: invalid_iresource.as_json }
          expect(assigns(:iresource)).to be_a_new(Iresource)
        end

        it "re-renders the 'new' template" do
          post :create, params: { iresource: invalid_iresource.as_json }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested iresource' do
          iresource = valid_iresources.first
          iresource.label = 'New valid label'
          put :update, params: { id: iresource.id, iresource: iresource.as_json }
          expect(iresource.reload.label).to eq 'New valid label'
        end

        it 'assigns the requested iresource as @iresource' do
          iresource = valid_iresources.first
          put :update, params: { id: iresource.to_param, iresource: iresource.as_json }
          expect(assigns(:iresource)).to eq(iresource)
        end

        it 'redirects to the iresource' do
          iresource = valid_iresources.first
          put :update, params: { id: iresource.to_param, iresource: iresource.as_json }
          expect(response).to redirect_to(iresource)
        end
      end

      describe 'with invalid params' do
        it 'assigns the iresource as @iresource' do
          iresource = valid_iresources.first
          iresource.label = '' #  not valid
          put :update, params: { id: iresource.id, iresource: iresource.as_json }
          expect(assigns(:iresource)).to eq(iresource)
        end

        it "re-renders the 'edit' template" do
          iresource = valid_iresources.first
          iresource.label = '' #  not valid
          put :update, params: { id: iresource.id, iresource: iresource.as_json }
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested iresource' do
      iresource = valid_iresources.first
      expect do
        delete :destroy, params: { id: iresource.id }
      end.to change(Iresource, :count).by(-1)
    end

    it 'redirects to the iresources list' do
      iresource = valid_iresources.first
      delete :destroy, params: { id: iresource.id }
      expect(response).to redirect_to(iresources_url)
    end
  end

  describe 'reports' do
    it 'render report print' do
      current_user = FactoryBot.create :user, position: 'big boss'
      iresource = create :iresource
      get :index, params: { format: 'pdf' }
      expect(response).to be_successful
    end
  end
end
