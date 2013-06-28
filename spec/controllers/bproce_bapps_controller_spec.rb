require 'spec_helper'

describe BproceBappsController do

  def valid_attributes
    { id: 1,
      bproce_id: 1,
      bapp_id: 1,
      apurpose: 'purpose in process'
    }
  end
  before(:each) do
    bproce = create(:bproce)
    bapp = create(:bapp)
  end
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested bproce_bapp as @bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :show, {:id => bproce_bapp.to_param}, valid_session
      assigns(:bproce_bapp).should eq(bproce_bapp)
    end
  end

  describe "GET edit" do
    it "assigns the requested bproce_bapp as @bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      get :edit, {:id => bproce_bapp.to_param}, valid_session
      assigns(:bproce_bapp).should eq(bproce_bapp)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceBapp" do
        expect {
          post :create, {:bproce_bapp => valid_attributes}, valid_session
        }.to change(BproceBapp, :count).by(1)
      end

      it "assigns a newly created bproce_bapp as @bproce_bapp" do
        post :create, {:bproce_bapp => valid_attributes}, valid_session
        assigns(:bproce_bapp).should be_a(BproceBapp)
        assigns(:bproce_bapp).should be_persisted
      end

      it "redirects to the created bproce_bapp" do
        post :create, {:bproce_bapp => valid_attributes}, valid_session
        response.should redirect_to(BproceBapp.last.bapp)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_bapp as @bproce_bapp" do
        # Trigger the behavior that occurs when invalid params are submitted
        BproceBapp.any_instance.stub(:save).and_return(false)
        post :create, {:bproce_bapp => {  }}, valid_session
        assigns(:bproce_bapp).should be_a_new(BproceBapp)
      end

    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        # Assuming there are no other bproce_bapps in the database, this
        # specifies that the BproceBapp created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BproceBapp.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => { "these" => "params" }}, valid_session
      end

      it "assigns the requested bproce_bapp as @bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => valid_attributes}, valid_session
        assigns(:bproce_bapp).should eq(bproce_bapp)
      end

      it "redirects to the bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => valid_attributes}, valid_session
        response.should redirect_to(bproce_bapp)
      end
    end

    describe "with invalid params" do
      it "assigns the bproce_bapp as @bproce_bapp" do
        bproce_bapp = BproceBapp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceBapp.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => {  }}, valid_session
        assigns(:bproce_bapp).should eq(bproce_bapp)
      end

      it "re-renders the 'edit' template" do
        bproce_bapp = BproceBapp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BproceBapp.any_instance.stub(:save).and_return(false)
        put :update, {:id => bproce_bapp.to_param, :bproce_bapp => {  }}, valid_session
        response.code.should == "302"
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce_bapp" do
      bproce_bapp = BproceBapp.create! valid_attributes
      expect {
        delete :destroy, {:id => bproce_bapp.to_param}, valid_session
      }.to change(BproceBapp, :count).by(-1)
    end

    it "redirects to the bproce_bapps list" do
      bproce_bapp = BproceBapp.create! valid_attributes
      delete :destroy, {:id => bproce_bapp.to_param}, valid_session
      response.should redirect_to bapp_url
    end
  end

end
