# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.create(:user) }
  let(:activity) { FactoryBot.create :activity, user_id: user.id }

  before do
    user = FactoryBot.create(:user)
    user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all activities as @activities' do
      get :index
      expect(response).to render_template('activities/index')
    end
    it 'return 200 OK' do
      get :index
      expect(response).to be_successful
    end
    it 'assign activities for letter' do
      letter = FactoryBot.create :letter, author_id: author.id
      get :index, params: { id: letter.id, type: 'letter' }
      expect(response).to render_template('activities/index')
    end
    it 'assign activities for contract' do
      contract = FactoryBot.create :contract, owner_id: author.id
      get :index, params: { id: contract.id, type: 'contract' }
      expect(response).to render_template('activities/index')
    end
    it 'assign activities for any type' do
      task = FactoryBot.create :task, author_id: author.id
      get :index, params: { id: task.id, type: 'task' }
      expect(response).to render_template('activities/index')
    end
  end
end
