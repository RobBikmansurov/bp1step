# frozen_string_literal: true

require 'rails_helper'

describe Requirement do
  let(:author)      { FactoryBot.create(:user) }
  let!(:user)        { FactoryBot.create(:user, displayname: 'DisplayName') }
  let(:requirement) { FactoryBot.create(:requirement, author_id: author.id, label: 'Подготовить ответ на запрос') }

  context 'validates' do
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_least(3).is_at_most(255) }
  end

  context 'associations' do
    it { should belong_to(:letter) }
    it { should belong_to(:author) }
    it { should have_many(:user) }
    it { should have_many(:user_requirement).dependent(:destroy) }
    it { should have_many(:task) }
  end

  context 'methods' do
    it 'return name' do
      expect(requirement.name).to eq ("[Подготовить ответ на запрос] от #{requirement.date.strftime('%d.%m.%y')}")
    end

    it 'return author_name' do
      expect(requirement.author_name).to eq(author.displayname)
    end

    it 'set author by author`s name ' do
      requirement.author_name = 'DisplayName'
      expect(requirement.author_name).to eq('DisplayName')
    end

    it 'return correct status_name' do
      expect(requirement.status_name).to eq('Новое') # REQUIREMENT_STATUS.key(0))
      requirement.status = 15
      expect(requirement.status_name).to eq('На исполнении') # REQUIREMENT_STATUS.key(15))
    end
  end
end
