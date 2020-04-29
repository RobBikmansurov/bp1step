# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/show' do
  let(:author) { create :user }
  let(:order)  { create :order, author: author }

  before :each do
    @order = order
    order_policy ||= OrderPolicy.new
  end

  it { puts @order.inspect }

  it 'renders attributes' do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
