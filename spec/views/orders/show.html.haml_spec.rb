# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/show', order_type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
                              order_type: 'Type',
                              codpred: 2,
                              author: nil,
                              contract_number: 'Contract Number',
                              status: 'Status',
                              result: 'MyText'
                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Contract Number/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/MyText/)
  end
end
