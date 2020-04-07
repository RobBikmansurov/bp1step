# frozen_string_literal: true

require 'rails_helper'

describe UserBusinessRoleMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:bproce) { FactoryBot.create(:bproce, user_id: user.id) }
  let!(:business_role) { FactoryBot.create(:business_role, bproce_id: bproce.id) }
  let!(:user_business_role) { UserBusinessRole.create(business_role_id: business_role.id, user_id: user.id) }

  describe 'user_create_role' do
    # рассылка о назначении исполнителя на роль в процессе
    let(:mail) { described_class.user_create_role(user_business_role, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Вы - исполнитель в процессе ##{bproce.id}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(bproce.name)
    end

    it '@text contains text' do
      expect(mail.body.encoded).to match('назначен исполнителем роли')
    end
  end

  describe 'user_delete_role' do
    # рассылка об удалении исполнителя из роли в процессе
    let(:mail) { described_class.user_delete_role(user_business_role, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: удален исполнитель из процесса ##{bproce.id}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(bproce.name)
    end

    it '@text contains text' do
      expect(mail.body.encoded).to match('больше не является исполнителем роли')
    end
  end
end
