# frozen_string_literal: true

require 'rails_helper'

PublicActivity.without_tracking do
  describe 'Public access to agents', type: :request do
    it 'denies access to agents#show' do
      agent = FactoryBot.create(:agent)
      get agent_path(id: agent.id)
      expect(response).to redirect_to new_user_session_path # sign_in
      follow_redirect!
    end

    it 'denies access to agents#new' do
      get new_agent_path
      expect(response).to redirect_to new_user_session_path # sign_in
    end

    it 'denies access to agents#index' do
      get agents_path
      expect(response).to redirect_to new_user_session_path # sign_in
    end

    it 'denies access to agents#create' do
      agent_attributes = FactoryBot.attributes_for(:agent)
      expect do
        post '/agents', params: { agent: agent_attributes }
      end.not_to change(Agent, :count)

      expect(response).to redirect_to new_user_session_path
    end
  end
end
