# frozen_string_literal: true

require 'rails_helper'

describe Term do
  context 'with validates' do
    it { is_expected.to validate_uniqueness_of(:shortname) }
    it { is_expected.to validate_length_of(:shortname).is_at_least(2).is_at_most(50) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(200) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
