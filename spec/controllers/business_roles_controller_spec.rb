# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessRolesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let(:valid_attributes) do
    { name: 'business_role name', description: 'description', bproce_id: bproce.id, bproce_name: bproce.name }
  end
  let(:invalid_attributes) { { name: 'invalid value', bproce_id: bproce.id } }
  let(:business_role) { create :business_role, bproce_id: bproce.id }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all business_roles as @business_roles' do
      get :index, params: {}
      expect(response).to be_successful
      expect(response).to render_template('business_roles/index')
    end

    it 'loads all of the business_roles into @business_roles' do
      business_role1 = BusinessRole.create! valid_attributes
      business_role2 = BusinessRole.create! valid_attributes
      get :index
      expect(assigns(:business_roles)).to match_array([business_role1, business_role2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested business_role as @business_role' do
      business_role = BusinessRole.create! valid_attributes
      get :show, params: { id: business_role.to_param }
      expect(assigns(:business_role)).to eq(business_role)
    end
  end

  describe 'GET new' do
    it 'assigns a new business_role as @business_role' do
      get :new, params: { bproce_id: bproce.id }
      expect(assigns(:business_role)).to be_a_new(BusinessRole)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested business_role as @business_role' do
      business_role = BusinessRole.create! valid_attributes
      get :edit, params: { id: business_role.to_param }
      expect(assigns(:business_role)).to eq(business_role)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BusinessRole' do
        expect do
          post :create, params: { business_role: valid_attributes }
        end.to change(BusinessRole, :count).by(1)
      end

      it 'assigns a newly created business_role as @business_role' do
        post :create, params: { business_role: valid_attributes }
        expect(assigns(:business_role)).to be_a(BusinessRole)
        expect(assigns(:business_role)).to be_persisted
      end

      it 'redirects to the created business_role' do
        post :create, params: { business_role: valid_attributes }
        expect(response).to redirect_to(BusinessRole.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved business_role as @business_role' do
        post :create, params: { business_role: invalid_attributes }
        expect(assigns(:business_role)).to be_a_new(BusinessRole)
      end

      it "re-renders the 'new' template" do
        post :create, params: { business_role: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested business_role' do
        business_role = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).at_least(:once)
        put :update, params: { id: business_role.to_param, business_role: valid_attributes }
      end

      it 'assigns the requested business_role as @business_role' do
        business_role = BusinessRole.create! valid_attributes
        put :update, params: { id: business_role.to_param, business_role: valid_attributes }
        expect(assigns(:business_role)).to eq(business_role)
      end

      it 'redirects to the business_role' do
        business_role = BusinessRole.create! valid_attributes
        put :update, params: { id: business_role.to_param, business_role: valid_attributes }
        expect(response).to redirect_to(business_role)
      end
    end

    describe 'with invalid params' do
      it 'assigns the business_role as @business_role' do
        business_role = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).and_return(false)
        put :update, params: { id: business_role.to_param, business_role: invalid_attributes }
        expect(assigns(:business_role)).to eq(business_role)
      end

      it "re-renders the 'edit' template" do
        business_role = BusinessRole.create! valid_attributes
        expect_any_instance_of(BusinessRole).to receive(:save).and_return(false)
        put :update, params: { id: business_role.to_param, business_role: invalid_attributes }
        expect(response).to render_template('business_role_mailer/update_business_role')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested business_role' do
      business_role = BusinessRole.create! valid_attributes
      expect do
        delete :destroy, params: { id: business_role.to_param }
      end.to change(BusinessRole, :count).by(-1)
    end

    it 'redirects to the business_roles list' do
      business_role = BusinessRole.create! valid_attributes
      business_role.bproce_id = bproce.id
      delete :destroy, params: { id: business_role.to_param }
      expect(response).to redirect_to(bproce_business_role_url(bproce))
    end
  end

  describe 'update_user' do
    it 'save user and show business_role' do
      user = create :user
      user_business_role = create :user_business_role, user_id: user.id, business_role_id: business_role.id
      put :update_user, params: { id: business_role.to_param,
                                  user_business_role: { user_id: user.id,
                                                        business_role_id: business_role.id, status: 0, user_name: user.displayname } }
      expect(assigns(:business_role)).to eq(business_role)
    end
  end

  it 'mail_all' do
    # get :mail_all, params: { id: business_role.id }
    # expect(assigns(response)).to render_template :show
  end

  describe 'reports' do
    it 'render report print' do
      current_user = FactoryBot.create :user
      get :index, params: { format: 'odt' }
      expect(response).to be_successful
    end
  end
end
