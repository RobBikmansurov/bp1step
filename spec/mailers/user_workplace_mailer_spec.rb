# frozen_string_literal: true

require 'rails_helper'

describe UserWorkplaceMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:workplace) { FactoryBot.create(:workplace) }
  let!(:user_workplace) { FactoryBot.create(:user_workplace, workplace_id: workplace.id, user_id: user.id) }

  describe 'user_workplace_create' do
    # рассылка о назначении исполнителя
    let(:mail) { described_class.user_workplace_create(user_workplace, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Ваше Рабочее место - #{workplace.designation}")
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
      expect(mail.body.encoded).to match('Вам назначено')
    end
  end

  describe 'user_workplace_destroy' do
    # рассылка об удалении исполнителя
    let(:mail) { described_class.user_workplace_destroy(user_workplace, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Рабочее место #{workplace.designation}")
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
      expect(mail.body.encoded).to match('не ваше.')
    end
  end
end
