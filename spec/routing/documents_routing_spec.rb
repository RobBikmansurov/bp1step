# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/documents').to route_to('documents#index')
    end

    it 'routes to #new' do
      expect(get: '/documents/new').to route_to('documents#new')
    end

    it 'routes to #show' do
      expect(get: '/documents/1').to route_to('documents#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/documents/1/edit').to route_to('documents#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/documents').to route_to('documents#create')
    end

    it 'routes to #update' do
      expect(put: '/documents/1').to route_to('documents#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/documents/1').to route_to('documents#destroy', id: '1')
    end

    it 'routes to #file_create' do
      expect(get: 'documents/1/file_create').to route_to('documents#file_create', id: '1')
    end
    it 'routes to #file_delete' do
      expect(get: 'documents/1/file_delete').to route_to('documents#file_delete', id: '1')
    end
    it 'routes to #update_file' do
      expect(patch: 'documents/1/update_file').to route_to('documents#update_file', id: '1')
    end
    it 'routes to #show_files' do
      expect(get: 'documents/1/show_files').to route_to('documents#show_files', id: '1')
    end

    it 'routes to bproces documents' do
      expect(get: '/bproces/1/documents').to route_to('documents#index', bproce_id: '1')
    end
    it 'routes to #clone document' do
      expect(get: '/documents/1/clone').to route_to('documents#clone', id: '1')
    end

    it 'routes to #add_favorite' do
      expect(get: 'documents/1/add_favorite').to route_to('documents#add_favorite', id: '1')
    end
    it 'routes to #add_to_favorite' do
      expect(get: 'documents/1/add_to_favorite').to route_to('documents#add_to_favorite', id: '1')
    end
    it 'routes to #update_favorite' do
      expect(post: 'documents/1/update_favorite').to route_to('documents#update_favorite', id: '1')
    end
    it 'routes to #approval_sheet' do # Лист согласования
      expect(get: 'documents/1/approval_sheet').to route_to('documents#approval_sheet', id: '1')
    end
    it 'routes to #bproce_create' do
      expect(get: 'documents/1/bproce_create').to route_to('documents#bproce_create', id: '1')
    end
    it 'routes to #autocomplete' do
      expect(get: '/documents/autocomplete').to route_to('documents#autocomplete')
    end
  end
end
