# frozen_string_literal: true

require 'rails_helper'

describe Task do
  let(:author) { FactoryBot.create(:user) }
  let!(:user)   { FactoryBot.create(:user, displayname: 'DisplayName') }
  let(:task)   { FactoryBot.create(:task, author_id: author.id) }
  context 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(5).is_at_most(255) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:duedate) }
  end

  context 'associations' do
    it { should belong_to(:letter) }
    it { should belong_to(:requirement) }
    it { should belong_to(:author) }
    it { should have_many(:user_task).dependent(:destroy) }
  end

  context 'methods' do
    it 'return action' do
      expect(task.action).to eq ('')
    end

    it 'return author_name' do
      expect(task.author_name).to eq(author.displayname)
    end

    it 'set author by author`s name ' do
      task.author_name = 'DisplayName'
      expect(task.author_name).to eq('DisplayName')
    end

    it 'return correct status_name' do
      expect(task.status_name).to eq('Новая')
      task.status = 50
      expect(task.status_name).to eq('На исполнении')
    end
  end

end
