RSpec.describe 'Requirements', type: :request do
  describe 'GET /requirements' do
    it 'works! (now write some real specs)' do
      get requirements_path
      expect(response).to have_http_status(200)
    end
  end
end
