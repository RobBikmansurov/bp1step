# frozen_string_literal: true
class LetterMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  def check_overdue_letters(letter, emails) # рассылка исполнителям о просроченных письмах
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

  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
  def update_letter(letter, current_user, result) # рассылка об изменении письма
    @letter = letter
    @current_user = current_user
    @result = result
    address = ''
    @letter.user_letter.each do |user_letter|
      if user_letter.user && !user_letter.user.email.empty?
        address += ', ' unless address.empty?
        address += user_letter.user.email
      end
    end
    mail(to: address,
         subject: "BP1Step: Письмо #{@letter.name} [#{LETTER_STATUS.key(@letter.status)}] изменено")
  end
end
