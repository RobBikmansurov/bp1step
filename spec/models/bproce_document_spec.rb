# frozen_string_literal: true

require 'rails_helper'

describe BproceDocument do
  let(:user) { FactoryBot.create :user }
  let(:bproce) { FactoryBot.create :bproce, user_id: user.id }
  let(:owner) { FactoryBot.create :user }
  let(:document) { FactoryBot.create :document, owner_id: owner.id }

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:document) }
  end
  it 'set bproce by name' do
    bproce_document = FactoryBot.create :bproce_document, bproce_id: bproce.id, document_id: document.id
    _bproce_new = FactoryBot.create :bproce, user_id: user.id, name: 'BPROCE_NAME'
    bproce_document.bproce_name = 'BPROCE_NAME'
    expect(bproce_document.bproce_name).to eq('BPROCE_NAME')
  end
end
