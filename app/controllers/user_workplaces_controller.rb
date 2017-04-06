class UserWorkplacesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[new create destroy]

  def show
    @user_workplace = UserWorkplace.find(params[:id])   # нашли удаляемую связь
    redirect_to workplace_path(@user_workplace.workplace_id) and return
  end

  def new
    @user_workplace = UserWorkplace.new
  end

  def create
    @user_workplace = UserWorkplace.create(params[:user_workplace])
    flash[:notice] = 'Successfully created user_workplace.' if @user_workplace.save
    respond_with(@user_workplace)
  end

  def destroy
    @user_workplace = UserWorkplace.find(params[:id])   # нашли удаляемую связь
    @workplace = Workplace.find(@user_workplace.workplace_id) # запомнили рабочее место для этой удаляемой связи
    begin
      UserWorkplaceMailer.user_workplace_destroy(@user_workplace, current_user).deliver_now # оповестим сотрудника
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_workplace.user.email}"
    end
    @user_workplace.destroy   # удалили связь
    respond_with(@workplace)  # вернулись в рабочее место
  end
end
