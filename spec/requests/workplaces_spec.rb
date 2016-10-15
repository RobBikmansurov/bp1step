require 'spec_helper'

RSpec.describe 'Workplaces', type: :request do
  describe 'GET /workplaces' do
    it 'works! (now write some real specs)' do
      get workplaces_path
      expect(response).to have_http_status(200)
    end
  end
end
