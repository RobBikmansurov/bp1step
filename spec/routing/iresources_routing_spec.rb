# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IresourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/iresources').to route_to('iresources#index')
    end

    it 'routes to #new' do
      expect(get: '/iresources/new').to route_to('iresources#new')
    end

    it 'routes to #show' do
      expect(get: '/iresources/1').to route_to('iresources#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/iresources/1/edit').to route_to('iresources#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/iresources').to route_to('iresources#create')
    end

    it 'routes to #update' do
      expect(put: '/iresources/1').to route_to('iresources#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/iresources/1').to route_to('iresources#destroy', id: '1')
    end
  end
end
