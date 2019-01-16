# frozen_string_literal: true

require 'rails_helper'

describe UserWorkplace do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:workplace_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:workplace) }
  end
end
