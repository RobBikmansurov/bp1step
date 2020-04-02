# frozen_string_literal: true

require 'rails_helper'

describe BproceIresource do
  let(:owner)            { FactoryBot.create(:user) }
  let(:parent)           { FactoryBot.create(:bproce, user_id: owner.id) }
  let(:bproce)           { FactoryBot.create(:bproce, user_id: owner.id, parent_id: parent.id) }
  let(:iresource)        { FactoryBot.create :iresource }
  let(:iresource0)       { FactoryBot.create :iresource }
  let(:bproce0)          { FactoryBot.create(:bproce, user_id: owner.id, parent_id: parent.id) }
  let(:bproce_iresource) { FactoryBot.create :bproce_iresource, bproce_id: bproce0.id, iresource_id: iresource0.id }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:bproce_id) }
    it { is_expected.to validate_presence_of(:iresource_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:iresource) }
  end

  it 'set bproce by name' do
    bproce_iresource.bproce_name = bproce.name
    expect(bproce_iresource.bproce_name).to eq(bproce.name)
  end

  it 'set iresource by label' do
    bproce_iresource.iresource_label = iresource.label
    expect(bproce_iresource.iresource_label).to eq(iresource.label)
  end
end
