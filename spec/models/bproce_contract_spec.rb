# frozen_string_literal: true

require 'rails_helper'

describe BproceContract do
  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to belong_to(:contract) }
  end
end
