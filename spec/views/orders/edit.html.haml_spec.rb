# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/edit' do
  let(:author) { create :user }
  let!(:order) { create :order, author: author }
  let(:bproce) { create :bproce, user: author }
  before :each do
    @order = Order.find(order.id)
    Rails.configuration.x.dms.process_ko = bproce.id
  end

  it 'renders the edit order form' do
    render

    assert_select 'form[action=?][method=?]', order_path(@order), 'post' do
      assert_select 'input[name=?]', 'order[order_type]'

      assert_select 'input[name=?]', 'order[codpred]'

      assert_select 'textarea[name=?]', 'order[result]'
    end
  end
end
