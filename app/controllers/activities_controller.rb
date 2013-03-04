class ActivitiesController < ApplicationController
  def index
  	@activities = PublicActivity::Activity.order("created_at desc").paginate(:per_page => 100, :page => params[:page])
  end
end
