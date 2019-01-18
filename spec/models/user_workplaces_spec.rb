# frozen_string_literal: true

require 'rails_helper'

describe UserWorkplace do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:workplace_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:workplace) }
  end
  it 'set user by username' do
    workplace = FactoryBot.create :workplace
    _user = FactoryBot.create :user, displayname: 'Иванов'
    user_workplace = FactoryBot.create :user_workplace, workplace_id: workplace.id
    user_workplace.user_name = 'Иванов'
    expect(user_workplace.user_name).to eq('Иванов')
  end
end
