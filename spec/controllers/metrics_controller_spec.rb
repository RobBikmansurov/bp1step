# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetricsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let(:valid_attributes)   { { name: 'Metric name', description: 'description1', bproce_id: bproce.id, depth: 1 } }
  let(:invalid_attributes) { { name: 'Metric name', description: 'description1', bproce_id: bproce.id, depth: 1 } }
  let(:valid_session)      { {} }
  let!(:metric) { FactoryBot.create :metric, bproce_id: bproce.id }
  let!(:metric1) { FactoryBot.create :metric, bproce_id: bproce.id }
  let(:input) { Metric.all }
  let(:params) { {} }

  describe 'GET index' do
    it 'assigns all metrics as @metrics' do
      get :index, params: {}
      expect(response).to be_successful
      expect(response).to render_template('metrics/index')
    end
    it 'loads all of the metrics into @metricss' do
      get :index
      expect(assigns(:metrics)).to match_array([metric, metric1])
    end
  end

  describe 'GET show' do
    it 'assigns the requested metric as @metric' do
      # get :show, params: { id: metric.to_param, depth: 3 }
      # !!! error - Time zones not supported for SQLite
      # expect(response).to be_successful
      # expect(assigns(:metric)).to eq(@metric)
    end
  end

  describe 'GET new' do
    it 'assigns a new metric as @metric' do
      get :new, params: {}
      expect(assigns(:metric)).to be_a_new(Metric)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested metric as @metric' do
      metric = Metric.create! valid_attributes
      get :edit, params: { id: metric.to_param }
      expect(assigns(:metric)).to eq(metric)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Metric' do
        expect do
          post :create, params: { metric: valid_attributes }
        end.to change(Metric, :count).by(1)
      end

      it 'assigns a newly created metric as @metric' do
        post :create, params: { metric: valid_attributes }
        expect(assigns(:metric)).to be_a(Metric)
        expect(assigns(:metric)).to be_persisted
      end

      it 'redirects to the created metric' do
        post :create, params: { metric: valid_attributes }
        expect(response).to redirect_to(Metric.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved metric as @metric' do
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        post :create, params: { metric: invalid_attributes }
        expect(assigns(:metric)).to be_a_new(Metric)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        post :create, params: { metric: { 'bproce' => 'invalid value' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested metric' do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).at_least(:once)
        put :update, params: { id: metric.to_param, metric: { name: 'agent name' } }
      end

      it 'assigns the requested metric as @metric' do
        metric = Metric.create! valid_attributes
        put :update, params: { id: metric.to_param, metric: valid_attributes }
        expect(assigns(:metric)).to eq(metric)
      end

      it 'redirects to the metric' do
        metric = Metric.create! valid_attributes
        put :update, params: { id: metric.to_param, metric: valid_attributes }
        expect(response).to redirect_to(metric)
      end
    end

    describe 'with invalid params' do
      it 'assigns the metric as @metric' do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        put :update, params: { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }
        expect(assigns(:metric)).to eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric = Metric.create! valid_attributes
        expect_any_instance_of(Metric).to receive(:save).and_return(false)
        put :update, params: { id: metric.to_param, metric: { 'bproce' => 'invalid value' } }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested metric' do
      metric = Metric.create! valid_attributes
      expect do
        delete :destroy, params: { id: metric.to_param }
      end.to change(Metric, :count).by(-1)
    end

    it 'redirects to the metrics list' do
      metric = Metric.create! valid_attributes
      delete :destroy, params: { id: metric.to_param }
      expect(response).to redirect_to(metrics_url)
    end
  end

  it 'render values' do
    get :values, params: { id: metric.to_param }
    expect(response).to render_template :values
  end

  it 'render new' do
    get :new_value, params: { id: metric.to_param }
    expect(response).to render_template :new
  end

  it 'set_values redirect to show' do
    metric = create :metric, bproce_id: bproce.id, mtype: 'PGSQL'
    get :set_values, params: { id: metric.to_param }
    expect(response).to redirect_to(action: :show)
  end

  it 'set render' do
    metric = create :metric, bproce_id: bproce.id, mhash: '123'
    # get :set, params: { id: metric.to_param, v: '1', h: '123' }
    # expect(response.status).to eq(404)
  end

  # subject { described_class.call(input, params) }

  # specify "no matching params" do
  #   expect(subject).to eq input
  # end

  # specify "searching" do
  #   params[:search] = "sms"
  #   # p input.search('www')
  #   # expect(subject).to eq input.search('sms')
  # end
  # specify 'depth' do
  #   params[:depth] = 1
  #   expect(subject).to eq input.depth('sms')
  # end
end
