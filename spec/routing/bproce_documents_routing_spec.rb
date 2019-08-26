# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BproceDocumentsController, type: :routing do
  describe 'routing -   resources :bproce_documents, :only => [:show]' do
    it 'routes to #show' do
      expect(get: '/bproce_documents/1').to route_to('bproce_documents#show', id: '1')
    end

    it 'redirect to /pages/about if route is broken' do
      # expect(get: '/bproce_documents').not_to be_routable
      expect(get: '/bproce_documents').to route_to(controller: 'pages', action: 'about', path: 'bproce_documents')
    end

    it 'routes to #edit' do
      expect(get: '/bproce_documents/1/edit').to route_to('bproce_documents#edit', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/bproce_documents/1').to route_to('bproce_documents#update', id: '1')
    end
  end
end
