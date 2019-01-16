# frozen_string_literal: true

require 'rails_helper'

describe BproceBapp do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:bproce_id) }
    it { is_expected.to validate_presence_of(:bapp_id) }
    it { is_expected.to validate_presence_of(:apurpose) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:bapp) }
  end
end
