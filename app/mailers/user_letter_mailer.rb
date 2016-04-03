# coding: utf-8
class UserLetterMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def user_letter_create(user_letter, current_user)		# рассылка о назначении исполнителя ответственным за письмо
    @user_letter = user_letter
    @letter = user_letter.letter
    @user = user_letter.user
    @current_user = current_user
    mail(:to => @user.email, :subject => "BP1Step: Вы - #{user_letter.status and user_letter.status > 0 ? 'отв.' : ''}исполнитель Письма ##{@letter.name}")
  end

  def user_letter_destroy(user_letter, current_user)		# рассылка об удалении исполнителя из ответственных
    @user_letter = user_letter
    @letter = user_letter.letter
    @user = user_letter.user
    @current_user = current_user
    mail(:to => @user.email, :subject => "BP1Step: удален исполнитель Письма ##{@letter.name}")
  end
end
