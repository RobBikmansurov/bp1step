RSpec.describe ActivitiesController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: "admin", description: 'description')
    sign_in @user

    allow(controller).to receive(:signed_in?).and_return(true)
    #allow(controller).to receive(:signed_in?).and_return(false)
  end

  describe 'GET "index" for auth user' do
    it 'renders the :index template' do
      sign_in user
      current_user

      get :index, user_id: user.id
      #response.should be_success
      response.should render_template :index
    end
  end

  describe 'GET "index" for not auth user' do
    it 'not renders the :index template' do
      sign_in nil
      get :index
      response.should_not be_success
    end
  end


end
