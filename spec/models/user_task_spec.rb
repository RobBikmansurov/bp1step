# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTask, type: :model do
  let(:author) { FactoryBot.create :user }
  let(:task)   { FactoryBot.create :task, author_id: author.id }
  let(:user)   { FactoryBot.create :user }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:task) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
  end

  it 'set user by name' do
    user_task = FactoryBot.create :user_task, task_id: task.id
    _user = FactoryBot.create :user, displayname: 'Иванов'
    user_task.user_name = 'Иванов'
    expect(user_task.user_name).to eq('Иванов')
  end

  it 'return отв. for user' do
    user_task = FactoryBot.create :user_task, task_id: task.id, user_id: user.id, status: 1
    expect(user_task.responsible?).to eq(true)
  end
end
