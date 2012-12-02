require 'spec_helper'
require 'factory_girl'

describe BappsController do

  # This should return the minimal set of attributes required to create a valid
  # Bapp. As you add validations to Bapp, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :id => 1,
      :name => "test_name",
      :description => "test_description"
    }
  end

  describe "GET new" do
    before(:each) {
      @user = create(:user)
      @user.roles << create(:role)
      #sign_in @user
    }
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
      bapp = Bapp.create! valid_attributes
      get :index
      assigns(:bapps).should eq([bapp])
    end
  end

  describe "GET show" do
    it "assigns the requested bapp as @bapp" do
      bapp = Bapp.create! valid_attributes
      get :show, :id => bapp.id
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
        response.should render_template("bapps/new")
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
        response.should render_template("edit")
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
