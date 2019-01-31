# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetricValuesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let!(:metric) { FactoryBot.create :metric, bproce_id: bproce.id }
  let!(:metric1) { FactoryBot.create :metric, bproce_id: bproce.id }
  let(:valid_attributes)   { { metric_id: metric.id, dtime: Time.current, value: 1 } }
  let(:invalid_attributes) { { metric_id: nil, dtime: Time.current, value: 1 } }

  describe 'GET edit' do
    it 'assigns the requested metric_value as @metric_value' do
      metric_value = MetricValue.create! valid_attributes
      get :edit, params: { id: metric_value.to_param }
      expect(assigns(:metric_value)).to eq(metric_value)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new MetricValue' do
        expect do
          post :create, params: { metric_value: valid_attributes }
        end.to change(MetricValue, :count).by(1)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested metric' do
        metric_value = MetricValue.create! valid_attributes
        metric_value.metric_id = metric.id
        expect_any_instance_of(MetricValue).to receive(:save).at_least(:once)
        put :update, params: { id: metric_value.to_param, metric_value: valid_attributes }
      end

      it 'assigns the requested metric_value as @metric_value' do
        metric_value = MetricValue.create! valid_attributes
        put :update, params: { id: metric_value.to_param, metric_value: valid_attributes }
        expect(assigns(:metric_value)).to eq(metric_value)
      end

      it 'redirects to the metric_value' do
        metric_value = MetricValue.create! valid_attributes
        put :update, params: { id: metric_value.to_param, metric_value: valid_attributes }
        expect(response).to redirect_to(metric_url(metric) + '/values')
      end
    end

    describe 'with invalid params' do
      it 'assigns the metric_value as @metric_value' do
        metric_value = MetricValue.create! valid_attributes
        expect_any_instance_of(MetricValue).to receive(:save).and_return(false)
        put :update, params: { id: metric_value.to_param, metric_value: invalid_attributes }
        expect(assigns(:metric)).to eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric_value = MetricValue.create! valid_attributes
        metric_value.metric = nil
        expect_any_instance_of(MetricValue).to receive(:save).and_return(false)
        put :update, params: { id: metric_value.to_param, metric_value: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested metric' do
      metric_value = MetricValue.create! valid_attributes
      expect do
        delete :destroy, params: { id: metric_value.to_param }
      end.to change(MetricValue, :count).by(-1)
    end

    it 'redirects to the metrics list' do
      metric_value = MetricValue.create! valid_attributes
      delete :destroy, params: { id: metric_value.to_param }
      expect(response).to redirect_to(metric_url(metric) + '/values')
    end
  end
end
