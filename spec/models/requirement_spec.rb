# frozen_string_literal: true

require 'rails_helper'

describe Requirement do
  let(:author) { FactoryBot.create(:user) }
  let(:requirement) { FactoryBot.create(:requirement, author_id: author.id, label: 'Подготовить ответ на запрос') }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_least(3).is_at_most(255) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:user) }
    it { is_expected.to have_many(:user_requirement).dependent(:destroy) }
    it { is_expected.to have_many(:task) }
  end

  it 'return name' do
    expect(requirement.name).to eq "[Подготовить ответ на запрос] от #{requirement.date.strftime('%d.%m.%y')}"
  end

  it 'return author_name' do
    expect(requirement.author_name).to eq(author.displayname)
  end

  it 'set author by author`s name ' do
    FactoryBot.create(:user, displayname: 'DisplayName')
    requirement.author_name = 'DisplayName'
    expect(requirement.author_name).to eq('DisplayName')
  end

  it 'return correct status_name' do
    expect(requirement.status_name).to eq('Новое') # REQUIREMENT_STATUS.key(0))
  end
  it 'return correct status_name after update' do
    requirement.status = 15
    expect(requirement.status_name).to eq('На исполнении') # REQUIREMENT_STATUS.key(15))
  end
  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
