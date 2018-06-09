# frozen_string_literal: true

class UserRequirementMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка о назначении исполнителя
  def user_requirement_create(user_requirement, current_user)
    @user_requirement = user_requirement
    @requirement = user_requirement.requirement
    @user = user_requirement.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: Вы - #{user_requirement.status.positive? ? 'отв.' : ''}исполнитель Требования ##{@requirement.id}")
  end

  # рассылка об удалении исполнителя
  def user_requirement_destroy(user_requirement, current_user)
    @user_requirement = user_requirement
    @requirement = user_requirement.requirement
    @user = user_requirement.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: удален исполнитель Требования ##{@requirement.id}")
  end
end
