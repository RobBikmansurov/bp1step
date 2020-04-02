# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserOrder, type: :model do
  let(:author) { create :user }
  let(:order) { create :order, author_id: author.id, number: '123-1', date: '01.01.2019' }
  let(:user) { create :user }

  context 'with associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:user) }
  end
end
