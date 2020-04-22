# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/index', order_type: :view do
  let(:author) { FactoryBot.create(:user) }
  let(:order) { FactoryBot.create(:order, author_id: author.id) }
  let(:order1) { FactoryBot.create(:order, author_id: author.id) }

  it 'renders a list of orders' do
    render
    assert_select 'tr>td', text: 'Type'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 'Contract Number'.to_s, count: 2
    assert_select 'tr>td', text: 'Status'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
