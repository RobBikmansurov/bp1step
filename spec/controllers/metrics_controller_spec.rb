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

describe MetricsController do

  # This should return the minimal set of attributes required to create a valid
  # Metric. As you add validations to Metric, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "bproce" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MetricsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all metrics as @metrics" do
      metric = Metric.create! valid_attributes
      get :index, {}, valid_session
      assigns(:metrics).should eq([metric])
    end
  end

  describe "GET show" do
    it "assigns the requested metric as @metric" do
      metric = Metric.create! valid_attributes
      get :show, {:id => metric.to_param}, valid_session
      assigns(:metric).should eq(metric)
    end
  end

  describe "GET new" do
    it "assigns a new metric as @metric" do
      get :new, {}, valid_session
      assigns(:metric).should be_a_new(Metric)
    end
  end

  describe "GET edit" do
    it "assigns the requested metric as @metric" do
      metric = Metric.create! valid_attributes
      get :edit, {:id => metric.to_param}, valid_session
      assigns(:metric).should eq(metric)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Metric" do
        expect {
          post :create, {:metric => valid_attributes}, valid_session
        }.to change(Metric, :count).by(1)
      end

      it "assigns a newly created metric as @metric" do
        post :create, {:metric => valid_attributes}, valid_session
        assigns(:metric).should be_a(Metric)
        assigns(:metric).should be_persisted
      end

      it "redirects to the created metric" do
        post :create, {:metric => valid_attributes}, valid_session
        response.should redirect_to(Metric.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved metric as @metric" do
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        post :create, {:metric => { "bproce" => "invalid value" }}, valid_session
        assigns(:metric).should be_a_new(Metric)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        post :create, {:metric => { "bproce" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested metric" do
        metric = Metric.create! valid_attributes
        # Assuming there are no other metrics in the database, this
        # specifies that the Metric created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Metric.any_instance.should_receive(:update).with({ "bproce" => "" })
        put :update, {:id => metric.to_param, :metric => { "bproce" => "" }}, valid_session
      end

      it "assigns the requested metric as @metric" do
        metric = Metric.create! valid_attributes
        put :update, {:id => metric.to_param, :metric => valid_attributes}, valid_session
        assigns(:metric).should eq(metric)
      end

      it "redirects to the metric" do
        metric = Metric.create! valid_attributes
        put :update, {:id => metric.to_param, :metric => valid_attributes}, valid_session
        response.should redirect_to(metric)
      end
    end

    describe "with invalid params" do
      it "assigns the metric as @metric" do
        metric = Metric.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        put :update, {:id => metric.to_param, :metric => { "bproce" => "invalid value" }}, valid_session
        assigns(:metric).should eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric = Metric.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        put :update, {:id => metric.to_param, :metric => { "bproce" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested metric" do
      metric = Metric.create! valid_attributes
      expect {
        delete :destroy, {:id => metric.to_param}, valid_session
      }.to change(Metric, :count).by(-1)
    end

    it "redirects to the metrics list" do
      metric = Metric.create! valid_attributes
      delete :destroy, {:id => metric.to_param}, valid_session
      response.should redirect_to(metrics_url)
    end
  end

end
