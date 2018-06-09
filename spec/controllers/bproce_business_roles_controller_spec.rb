# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BproceBusinessRolesController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let(:business_role) { FactoryBot.create(:business_role, bproce_id: bproce.id) }
  let(:valid_session) { {} }

  describe 'GET show' do
    it 'assigns the requested busines_role as @busines_role' do
      # business_role1 = FactoryBot.create(:business_role, bproce_id: bproce.id)
      get :show, params: { id: bproce.to_param }
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('bproce_business_roles/show')
    end
  end
end
