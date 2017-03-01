# frozen_string_literal: true
require 'rails_helper'

# app/controllers/letters_controller.rb:181
# UserLetterMailer.user_letter_create(user_letter, current_user).deliver_now    # оповестим нового исполнителя

describe LetterMailer do
  describe 'рассылка исполнителям о просроченных письмах' do
    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @letter = Letter.new(number: '1', date: DateTime.current)
      LetterMailer.check_overdue_letters(@letter, ['your-blog@no-reply.com']) # рассылка исполнителям о просроченных письмах.deliver
    end

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
    it 'returns correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq "BP1Step: не исполнено Письмо #{@letter.name}"
    end
    it 'returns correct from email' do
      expect(ActionMailer::Base.deliveries.first.from).to eq ['your-blog@no-reply.com']
    end
  end

  describe 'check_overdue_letters' do
    # let(:mail) { LetterMailer.signup }
    let(:user) { mock_model User, name: 'Lucas', email: 'lucas@email.com' }
    let(:mail) { UserLetterMailer.user_letter_create(user).deliver_now }

    it 'renders the headers' do
      expect(mail.subject).to eq('BP1Step: не исполнено Письмо')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['bp1step@bankperm.ru'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
