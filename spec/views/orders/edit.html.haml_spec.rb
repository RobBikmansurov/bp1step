# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/edit', order_type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
                              order_type: '',
                              codpred: 1,
                              author: nil,
                              contract_number: 'MyString',
                              status: 'MyString',
                              result: 'MyText'
                            ))
  end

  it 'renders the edit order form' do
    render

    assert_select 'form[action=?][method=?]', order_path(@order), 'post' do
      assert_select 'input[name=?]', 'order[order_type]'

      assert_select 'input[name=?]', 'order[codpred]'

      assert_select 'input[name=?]', 'order[author_id]'

      assert_select 'input[name=?]', 'order[contract_number]'

      assert_select 'input[name=?]', 'order[status]'

      assert_select 'textarea[name=?]', 'order[result]'
    end
  end
end
