# frozen_string_literal: true

require 'rails_helper'

describe Order do
  let(:author) { create :user }
  let(:order) { create :order, author_id: author.id, number: '123-1', date: '01.01.2019' }

  context 'with associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:user_order).dependent(:destroy) }
  end
end
