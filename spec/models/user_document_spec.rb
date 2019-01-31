# frozen_string_literal: true

require 'rails_helper'

describe UserDocument do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:document_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:document) }
    it { is_expected.to belong_to(:user) }
  end
end
