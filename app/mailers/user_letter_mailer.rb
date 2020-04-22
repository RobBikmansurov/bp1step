# frozen_string_literal: true

class UserLetterMailer < ApplicationMailer
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка о назначении исполнителя ответственным за письмо
  def user_letter_create(user_letter, current_user)
    @user_letter = user_letter
    @letter = user_letter.letter
    @user = user_letter.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: Вы - #{@user_letter&.status&.positive? ? 'отв.' : ''}исполнитель Письма ##{@letter.name}")
  end

  # рассылка об удалении исполнителя из ответственных
  def user_letter_destroy(user_letter, current_user)
    @user_letter = user_letter
    @letter = user_letter.letter
    @user = user_letter.user
    @current_user = current_user
    mail(to: @user.email,
         subject: "BP1Step: удален исполнитель Письма ##{@letter.name}")
  end
end
