# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MetricsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/metrics').to route_to('metrics#index')
    end

    it 'routes to #new' do
      expect(get: '/metrics/new').to route_to('metrics#new')
    end

    it 'routes to #show' do
      expect(get: '/metrics/1').to route_to('metrics#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/metrics/1/edit').to route_to('metrics#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/metrics').to route_to('metrics#create')
    end

    it 'routes to #update' do
      expect(put: '/metrics/1').to route_to('metrics#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/metrics/1').to route_to('metrics#destroy', id: '1')
    end

    it 'routes to #set' do
      expect(get: '/metrics/1/set').to route_to('metrics#set', id: '1')
    end
    it 'routes to #test' do
      expect(get: '/metrics/1/test').to route_to('metrics#test', id: '1')
    end
    it 'routes to #set_values' do
      expect(get: '/metrics/1/set_values').to route_to('metrics#set_values', id: '1')
    end
  end
end
