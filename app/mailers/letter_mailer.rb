# frozen_string_literal: true

class LetterMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка исполнителям о просроченных письмах
  def check_overdue_letters(letter, emails)
    @letter = letter
    mail(to: emails, subject: "BP1Step: не исполнено Письмо #{@letter.name}")
  end

  # рассылка исполнителям о наступлении срока исполнения письма
  def soon_deadline_letters(letter, emails, days, users)
    @letter = letter
    @users = users
    @days = days.to_i
    mail(to: emails, subject: "BP1Step: #{@days} дн. на Письмо #{@letter.name}")
  end

  # рассылка об изменении письма
  def update_letter(letter, current_user, _result)
    @letter = letter
    @current_user = current_user
    mail(to: not_empty_emails_for(@letter),
         subject: "BP1Step: Письмо #{@letter.name} [#{LETTER_STATUS.key(@letter.status)}] изменено")
  end

  private

  # список не пустых email исполнителей
  def not_empty_emails_for(letter)
    address = ''
    letter.user_letter.all.each do |user_letter|
      unless user_letter.user&.email&.empty?
        address += ', ' unless address.empty?
        address += user_letter.user.email
      end
    end
    address
  end
end
