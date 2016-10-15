RSpec.describe 'Metrics', type: :request do
  describe 'GET /metrics' do
    it 'works! (now write some real specs)' do
      get metrics_path
      expect(response).to have_http_status(200)
    end
  end
end
