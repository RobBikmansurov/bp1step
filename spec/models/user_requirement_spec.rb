# frozen_string_literal: true

require 'rails_helper'

describe UserRequirement do
  let(:author)      { FactoryBot.create :user }
  let(:requirement) { FactoryBot.create :requirement, author_id: author.id }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:requirement) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:requirement) }
    it { is_expected.to belong_to(:user) }
  end

  it 'set user by username' do
    _user = FactoryBot.create :user, displayname: 'Иванов'
    user_requirement = FactoryBot.create :user_requirement, requirement_id: requirement.id
    user_requirement.user_name = 'Иванов'
    expect(user_requirement.user_name).to eq('Иванов')
  end
end
