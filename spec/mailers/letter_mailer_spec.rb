# frozen_string_literal: true

require 'rails_helper'

describe LetterMailer do
  let!(:letter) { FactoryBot.create(:letter) }
  let!(:user) { FactoryBot.create(:user) }
  let(:user_letter) { FactoryBot.create(:user_letter, user_id: user.id, letter_id: letter.id) }

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
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains leter\'s subject' do
      expect(mail.body.encoded).to match(letter.subject)
    end
    it '@text contains leter\'s sender' do
      expect(mail.body.encoded).to match(letter.sender)
    end
    it '@text contains leter\'s body' do
      expect(mail.body.encoded).to match(letter.body)
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
    let!(:user_letter) { FactoryBot.create(:user_letter, user_id: user.id, letter_id: letter.id) }
    let(:mail) { LetterMailer.update_letter(letter, user, 'updated') }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user_letter1) { FactoryBot.create(:user_letter, user_id: user1.id, letter_id: letter.id) }

    it 'renders the subject' do
      expect(mail.subject).to eql("BP1Step: Письмо #{letter.name} [#{LETTER_STATUS.key(letter.status)}] изменено")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email, user1.email].sort)
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'assigns @text' do
      expect(mail.body.encoded).to match('исполнитель')
      expect(mail.body.encoded).to match('в которое внесены изменения')
    end
  end
end
