class UserWorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@uw = User.find(params[:id])
  	respond_with(@workplaces = @uw.workplaces)
  end
end
