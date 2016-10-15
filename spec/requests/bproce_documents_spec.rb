RSpec.describe 'BproceDocuments', type: :request do
  describe 'GET /bproce_document/1' do
    it 'works! (now write some real specs)' do
      post bproce_documents_path
      expect(response).to have_http_status(200)
    end
  end
end
