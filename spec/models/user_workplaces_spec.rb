# frozen_string_literal: true
require 'rails_helper'

describe UserWorkplace do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:workplace_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:workplace) }
  end
end
