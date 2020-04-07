# frozen_string_literal: true

require 'rails_helper'

describe Letter do
  let(:author) { FactoryBot.create(:user) }
  let(:letter) { FactoryBot.create(:letter, author_id: author.id, number: '123-1', date: '01.01.2019') }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_length_of(:subject).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_length_of(:number).is_at_most(30) }
    it { is_expected.to validate_length_of(:source).is_at_most(20) }
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_length_of(:sender).is_at_least(3) }
    it { is_expected.to validate_presence_of(:date) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:user_letter).dependent(:destroy) }
    it { is_expected.to have_many(:letter_appendix).dependent(:destroy) }
  end

  it 'set author by author`s name ' do
    _user = FactoryBot.create(:user, displayname: 'DisplayName')
    letter.author_name = 'DisplayName'
    expect(letter.author_name).to eq('DisplayName')
  end

  it 'return correct status_name' do
    expect(letter.status_name).to eq('Новое')
  end

  it 'return correct status_name after update' do
    letter.status = 10
    expect(letter.status_name).to eq('На исполнении')
  end

  it 'set status by name' do
    letter.status_name = 'Завершено'
    expect(letter.status).to eq(90)
  end

  it 'return empty action' do
    expect(letter.action).to eq('')
  end

  it 'add action to result' do
    letter.result = '1'
    letter.action = '23'
    expect(letter.result).to eq('123')
  end

  it 'return name' do
    expect(letter.name).to eq('№123-1 от 01.01.19')
  end

  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
