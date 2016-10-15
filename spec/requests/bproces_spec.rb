require 'spec_helper'
RSpec.describe 'Bproces', type: :request do
  describe 'GET /bproces' do
    it 'works! (now write some real specs)' do
      get bproces_path
      expect(response).to have_http_status(200)
    end
  end
end
