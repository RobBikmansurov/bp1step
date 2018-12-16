# frozen_string_literal: true

require 'rails_helper'
RSpec.describe PagesController, type: :controller do

  it 'about' do
    get :about
    expect(get: "/about").to route_to(controller: 'pages', action: 'about')
  end
end
