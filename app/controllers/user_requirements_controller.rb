# frozen_string_literal: true

class UserRequirementsController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[new create destroy]

  def show
    @user_requirement = UserRequirement.find(params[:id])
    redirect_to(requirement_path(@user_requirement.requirement_id)) && return
  end

  def new
    @user_requirement = UserRequirement.new(status: 0)
  end

  def create
    @user_requirement = UserRequirement.new(user_rrquirement_params)
    if @user_requirement.save
      flash[:notice] = 'Successfully created user_requirement.'
      begin
        UserRequirementMailer.user_requirement_create(@user_requirement, current_user).deliver_now # оповестим нового исполнителя
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to #{@user_requirement.user.email}"
      end
      requirement = Requirement.find(@user_requirement.requirement_id)
      requirement.update_column(:status, 5) if requirement.status < 1 # если есть ответственные - статус = Назначено
    else
      flash[:alert] = 'Error create user_requirement'
    end
    respond_with(@user_requirement)
  end

  def destroy
    @user_requirement = UserRequirement.find(params[:id]) # нашли удаляемую связь
    @requirement = Requirement.find(@user_requirement.requirement_id) # запомнили требование для этой удаляемой связи
    begin
      UserRequirementMailer.user_requirement_destroy(@user_requirement, current_user).deliver_now # оповестим исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_requirement.user.email}"
    end
    if @user_requirement.destroy # удалили связь
      @requirement.update_column(:status, 0) unless @requirement.user_requirement.first # если нет ответственных - статус = Новое
    end
    respond_with(@requirement) # вернулись в требование
  end

  private

  def user_rrquirement_params
    params.require(:user_requirement).permit(:user_id, :requirement_id, :status, :user_name)
  end
end
