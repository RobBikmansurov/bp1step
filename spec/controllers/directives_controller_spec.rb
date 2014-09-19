require 'spec_helper'

describe DirectivesController do

  def valid_attributes
    {
      id: 1,
      approval: "01.01.2013",
      number: "100",
      name: "directive_name",
      body: "test"
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
    it "assigns all directives as @directives" do
      directive = Directive.create! valid_attributes
      get :index, {}, valid_session
      assigns(:directives).should eq([directive])
    end
  end

  describe "GET show" do
    it "assigns the requested directive as @directive" do
      directive = Directive.create! valid_attributes
      get :show, {:id => directive.to_param}, valid_session
      assigns(:directive).should eq(directive)
    end
  end

  describe "GET new" do
    it "assigns a new directive as @directive" do
      get :new, {}, valid_session
      assigns(:directive).should be_a_new(Directive)
    end
  end

  describe "GET edit" do
    it "assigns the requested directive as @directive" do
      directive = Directive.create! valid_attributes
      get :edit, {:id => directive.to_param}, valid_session
      assigns(:directive).should eq(directive)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Directive" do
        expect {
          post :create, {:directive => valid_attributes}, valid_session
        }.to change(Directive, :count).by(1)
      end

      it "assigns a newly created directive as @directive" do
        post :create, {:directive => valid_attributes}, valid_session
        assigns(:directive).should be_a(Directive)
        assigns(:directive).should be_persisted
      end

      it "redirects to the created directive" do
        post :create, {:directive => valid_attributes}, valid_session
        response.should redirect_to(Directive.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved directive as @directive" do
        # Trigger the behavior that occurs when invalid params are submitted
        Directive.any_instance.stub(:save).and_return(false)
        post :create, {:directive => {}}, valid_session
        assigns(:directive).should be_a_new(Directive)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Directive.any_instance.stub(:save).and_return(false)
        post :create, {:directive => {}}, valid_session
        response.should_not render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested directive" do
        directive = Directive.create! valid_attributes
        # Assuming there are no other directives in the database, this
        # specifies that the Directive created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Directive.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => directive.to_param, :directive => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested directive as @directive" do
        directive = Directive.create! valid_attributes
        put :update, {:id => directive.to_param, :directive => valid_attributes}, valid_session
        assigns(:directive).should eq(directive)
      end

      it "redirects to the directive" do
        directive = Directive.create! valid_attributes
        put :update, {:id => directive.to_param, :directive => valid_attributes}, valid_session
        response.should redirect_to(directive)
      end
    end

    describe "with invalid params" do
      it "assigns the directive as @directive" do
        directive = Directive.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Directive.any_instance.stub(:save).and_return(false)
        put :update, {:id => directive.to_param, :directive => {}}, valid_session
        assigns(:directive).should eq(directive)
      end

      it "re-renders the 'edit' template" do
        directive = Directive.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Directive.any_instance.stub(:save).and_return(false)
        put :update, {:id => directive.to_param, :directive => {}}, valid_session
        response.should_not render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested directive" do
      directive = Directive.create! valid_attributes
      expect {
        delete :destroy, {:id => directive.to_param}, valid_session
      }.to change(Directive, :count).by(-1)
    end

    it "redirects to the directives list" do
      directive = Directive.create! valid_attributes
      delete :destroy, {:id => directive.to_param}, valid_session
      response.should redirect_to(directives_url)
    end
  end

end
