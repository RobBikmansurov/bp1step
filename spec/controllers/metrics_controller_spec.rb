# frozen_string_literal: true

RSpec.describe MetricsController, type: :controller do
  let(:valid_attributes) { { 'name' => 'Metric name', description: 'description1', bproce_id: 1, depth: 1 } }
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns all metrics as @metrics' do
      metric = Metric.create! valid_attributes
      get :index, {}, valid_session
      assigns(:metrics).should eq([metric])
    end
  end

  describe 'GET show' do
    it 'assigns the @metric' do
      @metric = Metric.create! valid_attributes
      # get :show, {id: @metric.id}, valid_session
      expect(response).to be_success
      # expect(response).to render_template(:show)
      # expect(assigns(:metric)).to eq(@metric)
    end
  end

  describe 'GET new' do
    it 'assigns a new metric as @metric' do
      get :new, {}, valid_session
      assigns(:metric).should be_a_new(Metric)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested metric as @metric' do
      metric = Metric.create! valid_attributes
      get :edit, { id: metric.to_param }, valid_session
      assigns(:metric).should eq(metric)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Metric' do
        expect do
          post :create, { metric: valid_attributes }, valid_session
        end.to change(Metric, :count).by(1)
      end

      it 'assigns a newly created metric as @metric' do
        post :create, { metric: valid_attributes }, valid_session
        assigns(:metric).should be_a(Metric)
        assigns(:metric).should be_persisted
      end

      it 'redirects to the created metric' do
        post :create, { metric: valid_attributes }, valid_session
        response.should redirect_to(Metric.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved metric as @metric' do
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        post :create, { metric: { 'bproce' => 'invalid value' } }, valid_session
        assigns(:metric).should be_a_new(Metric)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        post :create, { metric: { 'bproce' => 'invalid value' } }, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested metric' do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).at_least(:once)
        put :update, { id: metric.to_param, metric: { name: 'agent name' } }, valid_session
      end

      it 'assigns the requested metric as @metric' do
        metric = Metric.create! valid_attributes
        put :update, { id: metric.to_param, metric: valid_attributes }, valid_session
        assigns(:metric).should eq(metric)
      end

      it 'redirects to the metric' do
        metric = Metric.create! valid_attributes
        put :update, { id: metric.to_param, metric: valid_attributes }, valid_session
        response.should redirect_to(metric)
      end
    end

    describe 'with invalid params' do
      it 'assigns the metric as @metric' do
        metric = Metric.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        put :update, { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }, valid_session
        assigns(:metric).should eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric = Metric.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Metric.any_instance.stub(:save).and_return(false)
        put :update, { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested metric' do
      metric = Metric.create! valid_attributes
      expect do
        delete :destroy, { id: metric.to_param }, valid_session
      end.to change(Metric, :count).by(-1)
    end

    it 'redirects to the metrics list' do
      metric = Metric.create! valid_attributes
      delete :destroy, { id: metric.to_param }, valid_session
      response.should redirect_to(metrics_url)
    end
  end
end
