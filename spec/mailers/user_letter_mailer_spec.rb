# frozen_string_literal: true

require 'rails_helper'

describe UserLetterMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let!(:letter) { FactoryBot.create(:letter) }
  let!(:user_letter) { UserLetter.create(letter_id: letter.id, user_id: user.id) }

  describe 'user_letter_create' do
    # рассылка о назначении исполнителя ответственным за письмо
    let(:mail) { described_class.user_letter_create(user_letter, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Вы - исполнитель Письма ##{letter.name}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(user.displayname)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('исполнителем </a>')
    end
  end

  describe 'user_letter_destroy' do
    # рассылка об удалении исполнителя из ответственных
    let(:mail) { described_class.user_letter_destroy(user_letter, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: удален исполнитель Письма ##{letter.name}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(user.displayname)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('удален из исполнителей Письма')
    end
  end
end
