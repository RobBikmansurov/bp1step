# frozen_string_literal: true

require 'rails_helper'

describe BproceWorkplace do
  let(:user)        { FactoryBot.create :user }
  let(:bproce)      { FactoryBot.create :bproce, user_id: user.id, name: 'BPROCE_NAME' }
  let(:bproce_workplace) { FactoryBot.create :bproce_workplace, bproce_id: bproce.id }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:bproce_id) }
    it { is_expected.to validate_presence_of(:workplace_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:workplace) }
  end

  it 'set bproce by name' do
    bproce_workplace.bproce_name = 'BPROCE_NAME'
    expect(bproce_workplace.bproce_name).to eq('BPROCE_NAME')
  end

  it 'set workplace by designation' do
    _workplace = FactoryBot.create :workplace, designation: 'designation'
    bproce_workplace.workplace_designation = 'designation'
    expect(bproce_workplace.workplace_designation).to eq('designation')
  end
end
