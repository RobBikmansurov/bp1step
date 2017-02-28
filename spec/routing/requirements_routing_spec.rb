# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RequirementsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/requirements').to route_to('requirements#index')
    end

    it 'routes to #new' do
      expect(get: '/requirements/new').to route_to('requirements#new')
    end

    it 'routes to #show' do
      expect(get: '/requirements/1').to route_to('requirements#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/requirements/1/edit').to route_to('requirements#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/requirements').to route_to('requirements#create')
    end

    it 'routes to #update' do
      expect(put: '/requirements/1').to route_to('requirements#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/requirements/1').to route_to('requirements#destroy', id: '1')
    end

    it 'routes to #create_task' do
      expect(get: '/requirements/1/create_task').to route_to('requirements#create_task', id: '1')
    end
    it 'routes to #create_user' do
      expect(get: '/requirements/1/create_user').to route_to('requirements#create_user', id: '1')
    end
    # it "routes to #update_user" do
    #  expect(:post => "/requirements").to route_to("requirements#update_user")
    # end
    it 'routes to #tasks_list' do
      expect(get: '/requirements/1/tasks_list').to route_to('requirements#tasks_list', id: '1')
    end
  end
end
