require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DocumentDirectivesController do
  
  # This should return the minimal set of attributes required to create a valid
  # DocumentDirective. As you add validations to DocumentDirective, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      id: 1,
      directive_id: 1,
      document_id: 2
    }
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentDirectivesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all document_directives as @document_directives" do
      document_directive = DocumentDirective.create! valid_attributes
      get :index, {}, valid_session
      assigns(:document_directives).should eq([document_directive])
    end
  end

  describe "GET show" do
    it "assigns the requested document_directive as @document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      get :show, {:id => document_directive.to_param}, valid_session
      assigns(:document_directive).should eq(document_directive)
    end
  end

  describe "GET new" do
    it "assigns a new document_directive as @document_directive" do
      get :new, {}, valid_session
      assigns(:document_directive).should be_a_new(DocumentDirective)
    end
  end

  describe "GET edit" do
    it "assigns the requested document_directive as @document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      get :edit, {:id => document_directive.to_param}, valid_session
      assigns(:document_directive).should eq(document_directive)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DocumentDirective" do
        expect {
          post :create, {:document_directive => valid_attributes}, valid_session
        }.to change(DocumentDirective, :count).by(1)
      end

      it "assigns a newly created document_directive as @document_directive" do
        post :create, {:document_directive => valid_attributes}, valid_session
        assigns(:document_directive).should be_a(DocumentDirective)
        assigns(:document_directive).should be_persisted
      end

      it "redirects to the created document_directive" do
        post :create, {:document_directive => valid_attributes}, valid_session
        response.should redirect_to(DocumentDirective.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document_directive as @document_directive" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentDirective.any_instance.stub(:save).and_return(false)
        post :create, {:document_directive => {}}, valid_session
        assigns(:document_directive).should be_a_new(DocumentDirective)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentDirective.any_instance.stub(:save).and_return(false)
        post :create, {:document_directive => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        # Assuming there are no other document_directives in the database, this
        # specifies that the DocumentDirective created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DocumentDirective.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => document_directive.to_param, :document_directive => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested document_directive as @document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        put :update, {:id => document_directive.to_param, :document_directive => valid_attributes}, valid_session
        assigns(:document_directive).should eq(document_directive)
      end

      it "redirects to the document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        put :update, {:id => document_directive.to_param, :document_directive => valid_attributes}, valid_session
        response.should redirect_to(document_directive)
      end
    end

    describe "with invalid params" do
      it "assigns the document_directive as @document_directive" do
        document_directive = DocumentDirective.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentDirective.any_instance.stub(:save).and_return(false)
        put :update, {:id => document_directive.to_param, :document_directive => {}}, valid_session
        assigns(:document_directive).should eq(document_directive)
      end

      it "re-renders the 'edit' template" do
        document_directive = DocumentDirective.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DocumentDirective.any_instance.stub(:save).and_return(false)
        put :update, {:id => document_directive.to_param, :document_directive => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document_directive" do
      document_directive = DocumentDirective.create! valid_attributes
      expect {
        delete :destroy, {:id => document_directive.to_param}, valid_session
      }.to change(DocumentDirective, :count).by(-1)
    end

    it "redirects to the document_directives list" do
      document_directive = DocumentDirective.create! valid_attributes
      delete :destroy, {:id => document_directive.to_param}, valid_session
      response.should redirect_to(document_directives_url)
    end
  end

end
