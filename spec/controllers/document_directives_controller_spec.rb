require 'spec_helper'

describe DocumentDirectivesController do
  
  def valid_attributes
    {
      id: 1,
      directive_id: 1,
      document_id: 1
    }
  end
  def valid_session
    {}
  end
  before(:each) do
    @document = create(:document)
    @directive = create(:directive)
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
        response.code.should == "200"
        #response.should render_template("edit")
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
      response.should redirect_to(document_url)
    end
  end

end
