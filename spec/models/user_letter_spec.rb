# frozen_string_literal: true

require 'rails_helper'

describe UserLetter do
  let(:author) { FactoryBot.create :user }
  let(:letter)   { FactoryBot.create :letter, author_id: author.id }
  let(:user) { FactoryBot.create :user }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:letter) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:user) }
  end

  it 'set user by name' do
    user_letter = FactoryBot.create :user_letter, letter_id: letter.id
    _user = FactoryBot.create :user, displayname: 'Иванов'
    user_letter.user_name = 'Иванов'
    expect(user_letter.user_name).to eq('Иванов')
  end
end
