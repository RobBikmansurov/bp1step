class UserWorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
  	@uw = User.find(params[:id])
  	respond_with(@workplaces = @uw.workplaces)
  end

  def new
    @user_workplace = UserWorkplace.new
  end

  def create
    @bproce_bapp = BproceBapp.create(params[:bproce_bapp])
    flash[:notice] = "Successfully created bproce_bapp." if @bproce_bapp.save
    respond_with(@bproce_bapp.bapp)
  end

end
