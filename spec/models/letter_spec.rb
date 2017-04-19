# frozen_string_literal: true

require 'rails_helper'

describe Letter do
  context 'validates' do
    it { should validate_presence_of(:subject) }
    it { should validate_length_of(:subject).is_at_least(3).is_at_most(200) }
    it { should validate_presence_of(:number) }
    it { should validate_length_of(:number).is_at_most(30) }
    it { should validate_length_of(:source).is_at_most(20) }
    it { should validate_presence_of(:sender) }
    it { should validate_length_of(:sender).is_at_least(3) }
    it { should validate_presence_of(:date) }
  end

  context 'associations' do
    it { should belong_to(:letter) }
    it { should belong_to(:author) }
    it { should have_many(:user_letter).dependent(:destroy) }
    it { should have_many(:letter_appendix).dependent(:destroy) }
  end
end
