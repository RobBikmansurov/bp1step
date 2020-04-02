# frozen_string_literal: true

require 'rails_helper'

describe Bproce do
  let(:owner)  { FactoryBot.create(:user) }
  let(:parent) { FactoryBot.create(:bproce, user_id: owner.id) }
  let(:bproce) { FactoryBot.create(:bproce, user_id: owner.id, parent_id: parent.id) }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(10).is_at_most(250) }
    it { is_expected.to validate_presence_of(:shortname) }
    it { is_expected.to validate_uniqueness_of(:shortname) }
    it { is_expected.to validate_length_of(:shortname).is_at_least(1).is_at_most(50) }
    it { is_expected.to validate_length_of(:fullname).is_at_least(10).is_at_most(250) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:documents) }
    it { is_expected.to have_many(:business_roles).dependent(:destroy) }
    it { is_expected.to have_many(:bproce_workplaces).dependent(:destroy) }
    it { is_expected.to have_many(:workplaces).through(:bproce_workplaces) }
    it { is_expected.to have_many(:bproce_iresource).dependent(:destroy) }
    it { is_expected.to have_many(:iresource).through(:bproce_iresource) }
    it { is_expected.to have_many(:bproce_bapps).dependent(:destroy) }
    it { is_expected.to have_many(:bapps).through(:bproce_bapps) }
    it { is_expected.to have_many(:bproce_documents).dependent(:destroy) }
    # it { should belong_to(:bproce) } # процесс может имет родительский процесс
    it { is_expected.to belong_to(:user) } # владелец процессв
  end

  context 'with methods' do
    it 'return user_name' do
      expect(bproce.user_name).to eq(owner.displayname)
    end

    it 'set owner by owner`s name ' do
      FactoryBot.create(:user, displayname: 'DisplayName')
      bproce.user_name = 'DisplayName'
      expect(bproce.user_name).to eq('DisplayName')
    end

    it 'return parent process name' do
      expect(bproce.parent_name).to eq(parent.name)
    end

    it 'set parent process by name ' do
      FactoryBot.create(:bproce, user_id: owner.id, name: 'Parent Name')
      bproce.parent_name = 'Parent Name'
      expect(bproce.parent_name).to eq('Parent Name')
    end
  end
end
