RSpec.describe 'BproceBapps', type: :request do
  describe 'GET /bproces/1/bapps' do
    it 'works! (now write some real specs)' do
      post bproce_bapps_path
      expect(response).to have_http_status(200)
    end
  end
end
