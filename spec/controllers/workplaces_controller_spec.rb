require 'spec_helper'
require 'factory_girl'
describe WorkplacesController do
  render_views

  def valid_attributes
    {
      id: 1,
      name: "test_name",
      designation: "test_designation",
      designation: "test_designation",
      location: "office"
    }
  end
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
  end

  describe "GET index" do
    it "assigns all workplaces as @workplaces" do
      workplace = Workplace.create! valid_attributes
      get :index
      assigns(:workplaces).should eq([workplace])
    end
  end

  describe "GET show" do
    it "assigns the requested workplace as @workplace" do
      workplace = Workplace.create! valid_attributes
      get :show, :id => workplace.id
      assigns(:workplace).should eq(workplace)
    end
  end

  describe "GET new" do
    it "assigns a new workplace as @workplace" do
      get :new
      assigns(:workplace).should be_a_new(Workplace)
    end
  end

  describe "GET edit" do
    it "assigns the requested workplace as @workplace" do
      workplace = Workplace.create! valid_attributes
      get :edit, :id => workplace.id
      assigns(:workplace).should eq(workplace)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Workplace" do
        expect {
          post :create, :workplace => valid_attributes
        }.to change(Workplace, :count).by(1)
      end

      it "assigns a newly created workplace as @workplace" do
        post :create, :workplace => valid_attributes
        assigns(:workplace).should be_a(Workplace)
        assigns(:workplace).should be_persisted
      end

      it "redirects to the created workplace" do
        post :create, :workplace => valid_attributes
        response.should redirect_to(Workplace.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved workplace as @workplace" do
        # Trigger the behavior that occurs when invalid params are submitted
        Workplace.any_instance.stub(:save).and_return(false)
        post :create, :workplace => {}
        assigns(:workplace).should be_a_new(Workplace)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Workplace.any_instance.stub(:save).and_return(false)
        post :create, :workplace => {}
        response.should_not render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested workplace" do
        workplace = Workplace.create! valid_attributes
        Workplace.any_instance.should_receive(:update_attributes).with({'id' => '1'})
        put :update, :id => workplace.id, :workplace => {'id' => '1'}
      end

      it "assigns the requested workplace as @workplace" do
        workplace = Workplace.create! valid_attributes
        put :update, :id => workplace.id, :workplace => valid_attributes
        assigns(:workplace).should eq(workplace)
      end

      it "redirects to the workplace" do
        workplace = Workplace.create! valid_attributes
        put :update, :id => workplace.id, :workplace => valid_attributes
        response.should redirect_to(workplace)
      end
    end

    describe "with invalid params" do
      it "assigns the workplace as @workplace" do
        workplace = Workplace.create! valid_attributes
        Workplace.any_instance.stub(:save).and_return(false)
        put :update, :id => workplace.id, :workplace => {}
        assigns(:workplace).should eq(workplace)
      end

      it "re-renders the 'edit' template" do
        workplace = Workplace.create! valid_attributes
        Workplace.any_instance.stub(:save).and_return(false)
        put :update, :id => workplace.id, :workplace => {:id => 1}
        response.should_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested workplace" do
      workplace = Workplace.create! valid_attributes
      expect {
        delete :destroy, :id => workplace.id
      }.to change(Workplace, :count).by(-1)
    end

    it "redirects to the workplaces list" do
      workplace = Workplace.create! valid_attributes
      delete :destroy, :id => workplace.id
      response.should redirect_to(workplaces_url)
    end
  end

end
