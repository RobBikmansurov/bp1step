class UserBusinessRolesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :user_business_role, only: %i[destroy edit update show]
  before_action :authenticate_user!, except: %i[show create]

  def show
    redirect_to business_role_path(@user_business_role.business_role_id) and return
  end

  def new
    @user_business_role = UserBusinessRole.new(date_from: Date.today.strftime('%d.%m.%Y'), date_to: Date.today.change(month: 12, day: 31).strftime('%d.%m.%Y'))
  end

  def create
    @user_business_role = UserBusinessRole.create(params[:user_business_role])
    @business_role = BusinessRole.find(@user_business_role.business_role_id)
    flash[:notice] = 'Successfully created user_business_role.' if @user_business_role.save
    begin
      UserBusinessRoleMailer.user_create_role(@user_business_role, current_user).deliver    # оповестим нового исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_business_role.user.email}"
    end
    respond_with(@business_role)
  end

  def destroy
    @user_business_role.destroy
    begin
      UserBusinessRoleMailer.user_delete_role(@user_business_role, current_user).deliver    # оповестим бывшего исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_business_role.user.email}"
    end
    respond_with(@business_role)
  end

  def edit
    respond_with(@business_role)
  end

  def update
    flash[:notice] = 'Successfully updated user_business_role.' if @user_business_role.update_attributes(user_business_role_params)
    respond_with(@business_role)
  end

  private

  def user_business_role_params
    params.require(:user_business_role).permit(:date_from, :date_to, :note, :user_id, :business_role_id)
  end

  def user_business_role
    @user_business_role = UserBusinessRole.find(params[:id])
    @business_role = BusinessRole.find(@user_business_role.business_role_id)
  end
end
