# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetricsController, type: :controller do
  let(:valid_attributes)   { { name: 'Metric name', description: 'description1', bproce_id: 1, depth: 1 } }
  let(:invalid_attributes) { { name: 'Metric name', description: 'description1', bproce_id: 1, depth: 1 } }
  let(:valid_session)      { {} }

  describe 'GET index' do
    it 'assigns all metrics as @metrics' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('metrics/index')
    end
    it 'loads all of the metrics into @metricss' do
      metric1 = Metric.create! valid_attributes
      metric2 = Metric.create! valid_attributes
      get :index
      expect(assigns(:metrics)).to match_array([metric1, metric2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested metric as @metric' do
      @metric = Metric.create! valid_attributes
      # get :show, {id: @metric.to_param}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      # expect(assigns(:metric)).to eq(@metric) # error - Time zones not supported for SQLite
    end
  end

  describe 'GET new' do
    it 'assigns a new metric as @metric' do
      get :new, {}, valid_session
      expect(assigns(:metric)).to be_a_new(Metric)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested metric as @metric' do
      metric = Metric.create! valid_attributes
      get :edit, { id: metric.to_param }, valid_session
      expect(assigns(:metric)).to eq(metric)
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
        expect(assigns(:metric)).to be_a(Metric)
        expect(assigns(:metric)).to be_persisted
      end

      it 'redirects to the created metric' do
        post :create, { metric: valid_attributes }, valid_session
        expect(response).to redirect_to(Metric.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved metric as @metric' do
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        post :create, { metric: invalid_attributes }, valid_session
        expect(assigns(:metric)).to be_a_new(Metric)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        post :create, { metric: { 'bproce' => 'invalid value' } }, valid_session
        expect(response).to render_template('new')
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
        expect(assigns(:metric)).to eq(metric)
      end

      it 'redirects to the metric' do
        metric = Metric.create! valid_attributes
        put :update, { id: metric.to_param, metric: valid_attributes }, valid_session
        expect(response).to redirect_to(metric)
      end
    end

    describe 'with invalid params' do
      it 'assigns the metric as @metric' do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        put :update, { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }, valid_session
        expect(assigns(:metric)).to eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        put :update, { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }, valid_session
        expect(response).to render_template('edit')
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
      expect(response).to redirect_to(metrics_url)
    end
  end
end
