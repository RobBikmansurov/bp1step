# frozen_string_literal: true

require 'rails_helper'

describe UserRequirementMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:requirement) { FactoryBot.create(:requirement, author_id: user.id) }
  let!(:user_requirement) { FactoryBot.create(:user_requirement, requirement_id: requirement.id, user_id: user.id) }

  describe 'user_requirement_create' do
    # рассылка о назначении исполнителя
    let(:mail) { described_class.user_requirement_create(user_requirement, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Вы - отв.исполнитель Требования ##{requirement.id}")
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

  describe 'user_requirement_destroy' do
    # рассылка об удалении исполнителя
    let(:mail) { described_class.user_requirement_destroy(user_requirement, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: удален исполнитель Требования ##{requirement.id}")
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
      expect(mail.body.encoded).to match('удален из исполнителей Требования')
    end
  end
end
