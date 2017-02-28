# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DocumentDirectivesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/document_directives').to route_to('document_directives#index')
    end

    it 'routes to #new' do
      expect(get: '/document_directives/new').to route_to('document_directives#new')
    end

    it 'routes to #show' do
      expect(get: '/document_directives/1').to route_to('document_directives#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/document_directives/1/edit').to route_to('document_directives#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/document_directives').to route_to('document_directives#create')
    end

    it 'routes to #update' do
      expect(put: '/document_directives/1').to route_to('document_directives#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/document_directives/1').to route_to('document_directives#destroy', id: '1')
    end

    it 'routes to documents for directive' do
      expect(get: '/directives/1/documents').to route_to('documents#index', directive_id: '1')
    end
  end
end
