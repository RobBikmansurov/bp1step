# frozen_string_literal: true

require 'rails_helper'

describe Task do
  let(:author) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, author_id: author.id) }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(5).is_at_most(255) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:duedate) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:requirement) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:user_task).dependent(:destroy) }
  end

  it 'return action' do
    expect(task.action).to eq ''
  end

  it 'return author_name' do
    expect(task.author_name).to eq(author.displayname)
  end

  it 'set author by author`s name ' do
    _user = FactoryBot.create(:user, displayname: 'DisplayName')
    task.author_name = 'DisplayName'
    expect(task.author_name).to eq('DisplayName')
  end

  it 'set status by name' do
    task.status_name = 'На исполнении'
    expect(task.status_name).to eq('На исполнении')
  end

  it 'return correct status_name' do
    expect(task.status_name).to eq('Новая')
  end

  it 'return correct status_name after update' do
    task.status = 50
    expect(task.status_name).to eq('На исполнении')
  end

  it 'add action to result' do
    task.result = '1'
    task.action = '23'
    expect(task.result).to eq('123')
  end

  it 'have a search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end

  it 'have right status mark' do
    { 9 => '&#x2606;', 50 => '&#x2605;', 81 => '&#x2714;' }.each do |s, m|
      task.status = s
      expect(task.status_mark).to eq(m)
    end
  end
end
