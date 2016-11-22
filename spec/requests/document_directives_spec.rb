RSpec.describe 'DocumentDirectives', type: :request do
  describe 'GET /document_directives' do
    it 'works! (now write some real specs)' do
      get document_directives_path
      expect(response).to have_http_status(200)
    end
  end
end
