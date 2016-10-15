RSpec.describe 'BproceWorkplaces', type: :request do
  describe 'GET /bproce_workplaces/bproce' do
    it 'works! (now write some real specs)' do
      post bproce_workplaces_path
      expect(response).to have_http_status(302)
    end
  end
end
