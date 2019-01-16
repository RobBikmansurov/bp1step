# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LetterAppendix, type: :model do
  context 'with validates' do
    it { is_expected.to validate_presence_of(:letter_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:letter).class_name('Letter') }
  end

  context 'with attached file' do
    it { is_expected.to have_attached_file(:appendix) }
    it { is_expected.to validate_attachment_presence(:appendix) }
  end
end
