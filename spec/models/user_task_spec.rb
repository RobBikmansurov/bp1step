# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTask, type: :model do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:task) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
  end
end
