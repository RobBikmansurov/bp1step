# frozen_string_literal: true

require 'rails_helper'

# app/controllers/letters_controller.rb:181
# UserLetterMailer.user_letter_create(user_letter, current_user).deliver_now    # оповестим нового исполнителя

describe LetterMailer do
  let(:letter) { FactoryBot.create(:letter) }
  let(:user) { FactoryBot.create(:user) }

  describe 'check_overdue_letters' do
    # check_overdue_letters(letter, emails) # рассылка исполнителям о просроченных письмах
    let(:mail) { LetterMailer.check_overdue_letters(letter, [user.email]) }

    it 'should send an email' do
      # expect(ActionMailer::Base.deliveries.count).to eq 1
    end
    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: не исполнено Письмо #{letter.name}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
  end

  describe 'soon_deadline_letters' do
    # soon_deadline_letters(letter, emails, days, users)
    let(:mail) { LetterMailer.soon_deadline_letters(letter, [user.email], 1, user) }

    it 'renders the subject' do
      expect(mail.subject).to eql("BP1Step: 1 дн. на Письмо #{letter.name}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'assigns @text' do
      expect(mail.body.encoded).to match('исполнить ВСЕ требования письма')
    end
  end

  describe 'update_letter' do
    # update_letter(letter, current_user, result) # рассылка об изменении письма
    let(:current_user) { FactoryBot.create(:user, displayname: 'user') }
    let(:mail) { LetterMailer.update_letter(letter, [current_user.email], 'updated') }

    it 'renders the subject' do
      expect(mail.subject).to eql("BP1Step: 1 дн. на Письмо #{letter.name}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'assigns @text' do
      expect(mail.body.encoded).to match('исполнить ВСЕ требования письма')
    end
  end
end
