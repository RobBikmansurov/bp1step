# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BusinessRolesController, type: :controller do
  let(:user)             { FactoryGirl.create(:user) }
  let(:bproce)           { FactoryGirl.create(:bproce, user: user) }
  let(:valid_business_roles)  { FactoryGirl.create_list(:business_role, 2, bproce: bproce) }
  let(:invalid_business_role) { FactoryGirl.create(:business_role, :invalid) }

  describe 'GET index' do
    it 'assigns all business_roles as @business_roles' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('business_roles/index')
    end

    it 'loads all of the business_roles into @business_roles' do
      business_roles = valid_business_roles
      get :index
      expect(assigns(:business_roles)).to match_array(business_roles)
    end
  end

  describe 'GET show' do
    it 'assigns the requested business_role as @business_role' do
      business_role = valid_business_roles.first
      get :show, { id: business_role.to_param }
      expect(assigns(:business_role)).to eq(business_role)
    end
  end

  context 'with mocked authentication' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    describe 'GET new' do
      it 'assigns a new business_role as @business_role' do
        get :new
        expect(assigns(:business_role)).to be_a_new(BusinessRole)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested business_role as @business_role' do
        business_role = valid_business_roles.first
        get :edit, { id: business_role.to_param }
        expect(assigns(:business_role)).to eq(business_role)
      end
    end

    describe 'POST create' do
      let(:bproce)        { build(:bproce) }
      let(:business_role) { build(:business_role) }
      before { sign_in(user) } # для создания бизнес-роли юзер должен быть авторизован

      describe 'with valid params' do
        it 'creates a new BusinessRole' do
          expect do
            post :create, { business_role: business_role.as_json }
          end.to change(BusinessRole, :count).by(1)
        end

        it 'assigns a newly created business_role as @business_role' do
          post :create, { business_role: business_role.as_json }
          expect(assigns(:business_role)).to be_a(BusinessRole)
          expect(assigns(:business_role)).to be_persisted
        end

        it 'redirects to the created business_role' do
          post :create, { business_role: business_role.as_json }
          expect(response).to redirect_to(BusinessRole.last)
        end
      end

      describe 'with invalid params' do
        let(:invalid_business_role) {build(:business_role, :invalid)}
        it 'assigns a newly created but unsaved business_role as @business_role' do
          post :create, { business_role: invalid_business_role.as_json }
          expect(assigns(:business_role)).to be_a_new(BusinessRole)
        end

        it "re-renders the 'new' template" do
          post :create, { business_role: invalid_business_role.as_json }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested business_role' do
          business_role = valid_business_roles.first
          business_role.name = 'New valid name'
          put :update, { id: business_role.id, business_role: business_role.as_json }
          expect(business_role.reload.name).to eq 'New valid name'
        end

        it 'assigns the requested business_role as @business_role' do
          business_role = valid_business_roles.first
          put :update, { id: business_role.to_param, business_role: business_role.as_json }
          expect(assigns(:business_role)).to eq(business_role)
        end

        it 'redirects to the business_role' do
          business_role = valid_business_roles.first
          put :update, { id: business_role.to_param, business_role: business_role.as_json }
          expect(response).to redirect_to(business_role)
        end
      end

      describe 'with invalid params' do
        it 'assigns the business_role as @business_role' do
          business_role = valid_business_roles.first
          business_role.name = '' #  not valid
          put :update, { id: business_role.id, business_role: business_role.as_json }
          expect(assigns(:business_role)).to eq(business_role)
        end

        it "re-renders the 'edit' template" do
          business_role = valid_business_roles.first
          business_role.name = '' #  not valid
          put :update, { id: business_role.id, business_role: business_role.as_json }
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested business_role' do
      business_role = valid_business_roles.first
      expect do
        delete :destroy, { id: business_role.id }
      end.to change(BusinessRole, :count).by(-1)
    end

    it 'redirects to the business_roles list' do
      business_role = valid_business_roles.first
      delete :destroy, { id: business_role.id }
      # expect(response).to redirect_to(business_roles_url)
      expect(response).to redirect_to(bproce_business_role_path(bproce))
    end
  end
end
