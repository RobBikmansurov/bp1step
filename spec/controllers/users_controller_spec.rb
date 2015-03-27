RSpec.describe UsersController, type: :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns @usr' do
      get :show, {id: @user.id}
      expect(response).to be_success
      expect(response).to render_template(:show)
      expect(assigns(:usr)).to eq(@user)
    end

    it 'render users search collection' do
      # xhr :get, :show, id: @user.id, "search" => @user.displayname
      # expect(response).to be_success
      # expect(assigns(:users)).not_to be_empty
      # expect(response).to render_template(:index)
    end
  end

  describe 'GET uworkplaces' do
    it 'should be success' do
      xhr :get, :uworkplaces, {id: @user.id}, format: :html
      expect(response).to render_template(:uworkplaces)
    end
  end

  describe 'GET uroles' do
    it 'should be success' do
      xhr :get, :uroles, {id: @user.id}, format: :html
      expect(response).to render_template(:uroles)
    end
  end

  describe 'GET documents' do
    it 'should be success' do
      xhr :get, :documents, {id: @user.id}, format: :html
      expect(response).to render_template(:documents)
    end
  end

  describe 'GET contracts' do
    it 'should be success' do
      xhr :get, :contracts, {id: @user.id}, format: :html
      expect(response).to render_template(:contracts)
    end
  end

  describe 'GET resources' do
    it 'should be success' do
      xhr :get, :resources, {id: @user.id}, format: :html
      expect(response).to render_template(:resources)
    end
  end

  describe 'GET processes' do
    it 'should be success' do
      xhr :get, :processes, {id: @user.id}, format: :html
      expect(response).to render_template(:processes)
    end
  end

end
