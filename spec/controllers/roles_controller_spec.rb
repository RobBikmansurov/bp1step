# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:role) { FactoryBot.create(:role) }
  let(:role1) { FactoryBot.create(:role) }
  let(:role_attributes) { { name: 'test_role', description: 'test_role_description' } }
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns all roles as @roles' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('roles/index')
    end

    it 'loads all of the roles into @roles' do
      get :index
      expect(assigns(:roles)).to match_array([role, role1])
    end
  end

  describe 'GET show' do
    it 'assigns the requested role as @role' do
      get :show, params: { id: role.id }
      expect(assigns(:role)).to eq(role)
    end
  end
end
