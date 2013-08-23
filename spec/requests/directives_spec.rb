require 'spec_helper'

describe "Directives" do

  before do
    @role = FactoryGirl.create(:role) # создать роль по умолчанию
    @role.name = 'user'
    @role.save
  end

  before :each do
    @user = FactoryGirl.create(:user)
    #session[:user_id] = @user.id
    #sign_in @user
  end

  describe "GET /directives" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get directives_path
      response.status.should be(200)
    end

    it "creates a Directive and redirects to the Directive's page" do
      get "/directives/new"
      expect(response).to render_template(:new)

      post "/directives", :directive => {:name => "Directive"}

      expect(response).to redirect_to(assigns(:directive))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include("Successfully created directive.")
    end

  end
end
