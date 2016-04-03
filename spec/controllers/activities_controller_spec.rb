RSpec.describe ActivitiesController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end


  before(:each) do
    @activity = FactoryGirl.create(:activity)
  end

  context 'when user is logged' do
    before(:each) do
      session[:current_user] = @activity.user_id
    end

    it "shows all activities for signed in user" do
      get :index, {user_id: @activity.user_id}
      expect(response).to be_success      
    end  
  end

  context 'when user is anonymous' do
    it "redirects user to root path" do
      get :index, {user_id: @activity.user_id}
      expect(response).to redirect_to root_path
    end  
  end


  describe 'GET "index" for auth user' do
    it 'renders the :index template' do
      sign_in @user
      current_user = FactoryGirl.create(:user)

      get :index, { user_id: user.id }, valid_session
      #response.should be_success
      response.should render_template :index
      #expect(assigns(:users)).to eq([user])

    end
  end


end
