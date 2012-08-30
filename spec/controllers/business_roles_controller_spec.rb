require 'spec_helper'

describe BusinessBusinessRolesController do

  def valid_attributes
    {
      :id => 1,
      :description => "test_descr",
      :name => "test_name",
      :bproce_id => 1
    }
  end

  describe "GET index" do
    it "assigns all business_roles as @business_roles" do
      business_role = BusinessRole.create! valid_attributes
      get :index
      assigns(:business_roles).should eq([business_role])
    end
  end

  describe "GET show" do
    it "assigns the requested business_role as @business_role" do
      business_role = BusinessRole.create! valid_attributes
      get :show, :id => business_role.id
      assigns(:business_role).should eq(business_role)
    end
  end

  describe "GET new" do
    it "assigns a new business_role as @business_role" do
      get :new
      assigns(:business_role).should be_a_new(BusinessRole)
    end
  end

  describe "GET edit" do
    it "assigns the requested business_role as @business_role" do
      business_role = BusinessRole.create! valid_attributes
      get :edit, :id => business_role.id
      assigns(:business_role).should eq(business_role)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BusinessRole" do
        expect {
          post :create, :business_role => valid_attributes
        }.to change(BusinessRole, :count).by(1)
      end

      it "assigns a newly created business_role as @business_role" do
        post :create, :business_role => valid_attributes
        assigns(:business_role).should be_a(BusinessRole)
        assigns(:business_role).should be_persisted
      end

      it "redirects to the created business_role" do
        post :create, :business_role => valid_attributes
        response.should redirect_to(BusinessRole.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved business_role as @business_role" do
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        post :create, :business_role => {}
        assigns(:business_role).should be_a_new(BusinessRole)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        post :create, :business_role => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested business_role" do
        business_role = BusinessRole.create! valid_attributes
        # Assuming there are no other business_roles in the database, this
        # specifies that the BusinessRole created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BusinessRole.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => business_role.id, :business_role => {'these' => 'params'}
      end

      it "assigns the requested business_role as @business_role" do
        business_role = BusinessRole.create! valid_attributes
        put :update, :id => business_role.id, :business_role => valid_attributes
        assigns(:business_role).should eq(business_role)
      end

      it "redirects to the business_role" do
        business_role = BusinessRole.create! valid_attributes
        put :update, :id => business_role.id, :business_role => valid_attributes
        response.should redirect_to(business_role)
      end
    end

    describe "with invalid params" do
      it "assigns the business_role as @business_role" do
        business_role = BusinessRole.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        put :update, :id => business_role.id, :business_role => {}
        assigns(:business_role).should eq(business_role)
      end

      it "re-renders the 'edit' template" do
        business_role = BusinessRole.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BusinessRole.any_instance.stub(:save).and_return(false)
        put :update, :id => business_role.id, :business_role => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested business_role" do
      business_role = BusinessRole.create! valid_attributes
      expect {
        delete :destroy, :id => business_role.id
      }.to change(BusinessRole, :count).by(-1)
    end

    it "redirects to the business_roles list" do
      business_role = BusinessRole.create! valid_attributes
      delete :destroy, :id => business_role.id
      response.should redirect_to(business_roles_url)
    end
  end
end
