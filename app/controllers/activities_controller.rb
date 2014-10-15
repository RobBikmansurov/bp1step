class ActivitiesController < ApplicationController
  def index
    if params[:type].present?
      @activities = PublicActivity::Activity.where(trackable_type: "#{params[:type]}").paginate(:per_page => 100, :page => params[:page])
      if params[:id].present?
        @activities = PublicActivity::Activity.where(trackable_type: "#{params[:type]}", trackable_id: "#{params[:id]}").paginate(:per_page => 100, :page => params[:page])
      end
    else
      @activities = PublicActivity::Activity.order("created_at desc").paginate(:per_page => 100, :page => params[:page])
    end
  end
end
