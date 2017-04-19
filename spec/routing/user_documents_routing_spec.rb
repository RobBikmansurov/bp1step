# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #destroy' do
      expect(delete: '/documents/1').to route_to('documents#destroy', id: '1')
    end
  end
end
