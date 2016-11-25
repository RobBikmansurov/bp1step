require "rails_helper"

RSpec.describe 'Directives', type: :request do
  describe 'GET /directives' do
    it 'works! (now write some real specs)' do
      get directives_path
      expect(response).to have_http_status(200)
    end

    it "creates a Directive and redirects to the Directive's page" do
      get new_directive_path
      expect(response).to render_template(:new)

      post '/directives', :directive => {:name => 'Directive'}

      expect(response).to redirect_to(assigns(:directive))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include('Successfully created directive.')
    end

  end
end
