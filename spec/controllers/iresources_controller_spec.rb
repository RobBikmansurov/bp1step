require 'spec_helper'

describe IresourcesController do

  def valid_attributes
    {
      level: 'level',
      label: "resource",
      location: '\\location'
    }
  end
  def valid_session
    {}
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
  end

  describe "GET index" do
    it "assigns all iresources as @iresources" do
      iresource = Iresource.create! valid_attributes
      get :index, {}, valid_session
      assigns(:iresources).should eq([iresource])
    end
  end

  describe "GET show" do
    it "assigns the requested iresource as @iresource" do
      iresource = Iresource.create! valid_attributes
      get :show, {:id => iresource.to_param}, valid_session
      assigns(:iresource).should eq(iresource)
    end
  end

  describe "GET new" do
    it "assigns a new iresource as @iresource" do
      get :new, {}, valid_session
      assigns(:iresource).should be_a_new(Iresource)
    end
  end

  describe "GET edit" do
    it "assigns the requested iresource as @iresource" do
      iresource = Iresource.create! valid_attributes
      get :edit, {:id => iresource.to_param}, valid_session
      assigns(:iresource).should eq(iresource)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Iresource" do
        expect {
          post :create, {:iresource => valid_attributes}, valid_session
        }.to change(Iresource, :count).by(1)
      end

      it "assigns a newly created iresource as @iresource" do
        post :create, {:iresource => valid_attributes}, valid_session
        assigns(:iresource).should be_a(Iresource)
        assigns(:iresource).should be_persisted
      end

      it "redirects to the created iresource" do
        post :create, {:iresource => valid_attributes}, valid_session
        response.should redirect_to(Iresource.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved iresource as @iresource" do
        # Trigger the behavior that occurs when invalid params are submitted
        Iresource.any_instance.stub(:save).and_return(false)
        post :create, {:iresource => { "level" => "invalid value" }}, valid_session
        assigns(:iresource).should be_a_new(Iresource)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Iresource.any_instance.stub(:save).and_return(false)
        post :create, {:iresource => { "level" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested iresource" do
        iresource = Iresource.create! valid_attributes
        # Assuming there are no other iresources in the database, this
        # specifies that the Iresource created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Iresource.any_instance.should_receive(:update_attributes).with({ "level" => "MyString" })
        put :update, {:id => iresource.to_param, :iresource => { "level" => "MyString" }}, valid_session
      end

      it "assigns the requested iresource as @iresource" do
        iresource = Iresource.create! valid_attributes
        put :update, {:id => iresource.to_param, :iresource => valid_attributes}, valid_session
        assigns(:iresource).should eq(iresource)
      end

      it "redirects to the iresource" do
        iresource = Iresource.create! valid_attributes
        put :update, {:id => iresource.to_param, :iresource => valid_attributes}, valid_session
        response.should redirect_to(iresource)
      end
    end

    describe "with invalid params" do
      it "assigns the iresource as @iresource" do
        iresource = Iresource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Iresource.any_instance.stub(:save).and_return(false)
        put :update, {:id => iresource.to_param, :iresource => { "level" => "invalid value" }}, valid_session
        assigns(:iresource).should eq(iresource)
      end

      it "re-renders the 'edit' template" do
        iresource = Iresource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Iresource.any_instance.stub(:save).and_return(false)
        put :update, {:id => iresource.to_param, :iresource => { "level" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested iresource" do
      iresource = Iresource.create! valid_attributes
      expect {
        delete :destroy, {:id => iresource.to_param}, valid_session
      }.to change(Iresource, :count).by(-1)
    end

    it "redirects to the iresources list" do
      iresource = Iresource.create! valid_attributes
      delete :destroy, {:id => iresource.to_param}, valid_session
      response.should redirect_to(iresources_url)
    end
  end

end
