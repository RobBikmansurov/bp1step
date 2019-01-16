# frozen_string_literal: true

require 'rails_helper'

describe UserLetter do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:letter) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:user) }
  end
end
