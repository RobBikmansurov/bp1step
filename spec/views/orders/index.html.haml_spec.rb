# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/index' do
  let(:author) { create :user }
  let!(:order) { create :order, author: author }
  let!(:order1) { create :order, author: author }
  let(:bproce) { create :bproce, user: author }
  before :each do
    @orders = Order.all
    @date = order.created_at
    @month = @date
    Rails.configuration.x.dms.process_ko = bproce.id
  end

  it 'renders a list of orders' do
    allow(view).to receive_messages(will_paginate: nil) # Add this
    render
    expect(rendered).to match order.order_type
    expect(rendered).to match order1.order_type
    expect(rendered).to match order.author.displayname
  end
end
