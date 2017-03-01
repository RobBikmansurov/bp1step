# frozen_string_literal: true
RSpec.describe HomeController, type: :controller do
  before(:each) do
    # @user = FactoryGirl.create(:user)
    # @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    # sign_in @user

    # allow(controller).to receive(:authenticate_user!).and_return(true)
    # allow(controller).to receive(:signed_in?).and_return(false)

    # allow(controller).to receive(:signed_in?).and_return(true)
    # allow(controller).to receive(:signed_in?).and_return(false)
  end

  describe "GET 'index'" do
    it 'returns http success' do
      allow(controller).to receive(:signed_in?).and_return(false) # unsigned user
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(:success)

      allow(controller).to receive(:signed_in?).and_return(true) # signed user
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(:success)
    end
  end
end
