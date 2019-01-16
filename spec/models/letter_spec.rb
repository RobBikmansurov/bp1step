# frozen_string_literal: true

require 'rails_helper'

describe Letter do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_length_of(:subject).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_length_of(:number).is_at_most(30) }
    it { is_expected.to validate_length_of(:source).is_at_most(20) }
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_length_of(:sender).is_at_least(3) }
    it { is_expected.to validate_presence_of(:date) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:user_letter).dependent(:destroy) }
    it { is_expected.to have_many(:letter_appendix).dependent(:destroy) }
  end
end
