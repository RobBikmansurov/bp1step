# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/roles').to route_to('roles#index')
    end

    it 'routes to #show' do
      expect(get: '/roles/1').to route_to('roles#show', id: '1')
    end
  end
end
