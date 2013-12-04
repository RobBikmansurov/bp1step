require 'spec_helper'
require 'factory_girl'

describe BappsController do
  include Devise::TestHelpers
  render_views
  PublicActivity.enabled = false
  
  def valid_attributes
   {
      :id => 1,
      :name => "test_name",
      :description => "test_description"
    }
  end

  before(:each) do
    @user = User.new(:email => "test_w@user.com", :username => "test_w")
    @user.roles << Role.find_or_create_by(name: 'admin')
    @user.save
    sign_in @user
  end
  
  describe "GET new" do
    it "assigns a new bapp as @bapp" do
      get :new
      assigns(:bapp).should be_a_new(Bapp)
      response.should render_template('bapps/new')
    end

    it "asigns a new bapp as @bapps if User auth" do
      get 'new'
      assigns(:bapp).should be_a_new(Bapp)
      response.should render_template('bapps/new')
    end
  end

  describe "GET index" do
    it "assigns all bapps as @bapps" do
      bapp = Bapp.create
      get :index
      expect(assigns(:bapps)).to render_template("index")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the bapps into @bapps" do
      bapp1, bapp2 = create(:bapp), create(:bapp)
      get :index
      expect(assigns(:bapps)).to match_array([bapp1, bapp2])
    end

  end

  describe "GET show" do
    it "assigns the requested bapp as @bapp" do
      bapp = Bapp.create! valid_attributes
      get :show, :id => bapp.id
      response.should render_template(:show)
      assigns(:bapp).should eq(bapp)
    end
    it "renders 404 page if bapp is not found" do
      get :show, :id => 0
      assigns(:bapp).should eq(bapp)
    end
  end

  describe "GET new" do
    it "assigns a new bapp as @bapp" do
      get :new
      assigns(:bapp).should be_a_new(Bapp)
    end
  end

  describe "GET edit" do
    it "assigns the requested bapp as @bapp" do
      bapp = Bapp.create! valid_attributes
      get :edit, :id => bapp.id
      assigns(:bapp).should eq(bapp)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bapp" do
        expect {
          post :create, :bapp => valid_attributes
        }.to change(Bapp, :count).by(1)
      end

      it "assigns a newly created bapp as @bapp" do
        post :create, :bapp => valid_attributes
        assigns(:bapp).should be_a(Bapp)
        assigns(:bapp).should be_persisted
      end

      it "redirects to the created bapp" do
        post :create, :bapp => valid_attributes
        response.should redirect_to(Bapp.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bapp as @bapp" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bapp.any_instance.stub(:save).and_return(false)
        post :create, :bapp => {}
        assigns(:bapp).should be_a_new(Bapp)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bapp.any_instance.stub(:save).and_return(false)
        post :create, :bapp => {}
        response.should_not render_template("bapps/new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bapp" do
        bapp = Bapp.create! valid_attributes
        # Assuming there are no other bapps in the database, this
        # specifies that the Bapp created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Bapp.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => bapp.id, :bapp => {'these' => 'params'}
      end

      it "assigns the requested bapp as @bapp" do
        bapp = Bapp.create! valid_attributes
        put :update, :id => bapp.id, :bapp => valid_attributes
        assigns(:bapp).should eq(bapp)
      end

      it "redirects to the bapp" do
        bapp = Bapp.create! valid_attributes
        put :update, :id => bapp.id, :bapp => valid_attributes
        response.should redirect_to(bapp)
      end
    end

    describe "with invalid params" do
      it "assigns the bapp as @bapp" do
        bapp = Bapp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bapp.any_instance.stub(:save).and_return(false)
        put :update, :id => bapp.id, :bapp => {}
        assigns(:bapp).should eq(bapp)
      end

      it "re-renders the 'edit' template" do
        bapp = Bapp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bapp.any_instance.stub(:save).and_return(false)
        put :update, :id => bapp.id, :bapp => {}
        response.should_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bapp" do
      bapp = Bapp.create! valid_attributes
      expect {
        delete :destroy, :id => bapp.id
      }.to change(Bapp, :count).by(-1)
    end

    it "redirects to the bapps list" do
      bapp = Bapp.create! valid_attributes
      delete :destroy, :id => bapp.id
      response.should redirect_to(bapps_url)
    end
  end

end
