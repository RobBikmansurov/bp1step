# coding: utf-8
class LetterMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def check_overdue_letters(letter, emails)   # рассылка исполнителям о просроченных письмах
    @letter = letter
    mail(:to => emails, :subject => "BP1Step: не исполнено Письмо #{@letter.name}")
  end

  def soon_deadline_letters(letter, emails, days, users)   # рассылка исполнителям о наступлении срока исполнения письма
    @letter = letter
    @users = users
    @days = days.to_i
    mail(:to => emails, :subject => "BP1Step: #{@days} дн. на Письмо #{@letter.name}")
  end

end
