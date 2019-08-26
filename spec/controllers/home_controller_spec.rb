# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET 'index'" do
    it 'returns http success' do
      allow(controller).to receive(:signed_in?).and_return(false) # unsigned user
      get :index
      expect(response).to be_successful

      allow(controller).to receive(:signed_in?).and_return(true) # signed user
      get :index
      expect(response).to be_successful
    end
  end

  it 'creates letter' do
    user = FactoryBot.create :user, phone: '911'
    get :create_letter, params: { id: user.id }
    expect(response).to be_successful
  end
  it 'creates letter for registered user' do
    user = FactoryBot.create :user, phone: '911'
    user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in user
    allow(controller).to receive(:authenticate_user!).and_return(true)
    get :create_letter, params: { id: user.id }
    expect(response).to be_successful
  end
end
