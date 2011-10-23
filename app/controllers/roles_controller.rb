class RolesController < ApplicationController
  def create
    @b_proc = BProc.find(params[:b_proc_id])
    @roles = @b_proc.roles.create(params[:role])
    redirect_to b_proc_path(@b_proc)
  end
end
