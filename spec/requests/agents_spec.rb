RSpec.describe 'Agents', type: :request do
  describe 'GET /agents' do
    it 'works! (now write some real specs)' do
      get agents_path
      expect(response).to have_http_status(200)
    end
  end
end
