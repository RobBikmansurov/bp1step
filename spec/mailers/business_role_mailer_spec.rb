# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessRoleMailer, type: :mailer do
  let(:owner) { FactoryBot.create :user }
  let!(:bproce) { FactoryBot.create :bproce, user_id: owner.id }
  let!(:business_role) { FactoryBot.create :business_role, bproce_id: bproce.id }
  let(:current_user) { FactoryBot.create :user }
  let!(:user1) { FactoryBot.create :user, active: true }
  let!(:user2) { FactoryBot.create :user, active: true }
  let!(:user_business_role1) { FactoryBot.create(:user_business_role, business_role_id: business_role.id, user_id: user1.id) }
  let!(:user_business_role2) { FactoryBot.create(:user_business_role, business_role_id: business_role.id, user_id: user2.id) }

  # mail_all(business_role, current_user, text)
  let(:mail_all) { BusinessRoleMailer.mail_all(business_role, current_user, 'Рассылка') }
  let(:mail) { BusinessRoleMailer.update_business_role(business_role, current_user) }

  context 'Mail all users of business_role and bproce`s owner' do
    it 'is sent email to bproce`s owner' do
      expect(mail_all.to[2]).to eq owner.email
    end
    it 'is sent email to business_role executors' do
      expect(mail_all.to[0]).to eq user1.email
      # expect(mail_all.to[1]).to eq user2.email
    end
    it 'is having subject with business_role.name and bproce.id' do
      expect(mail_all.subject).to eq "BP1Step: рассылка исполнителям [#{business_role.name}] в процессе ##{bproce.id}"
    end
    it 'is having sender`s name in the text' do
      expect(mail_all.body.encoded).to match(current_user.displayname)
    end
    it 'is having text of the mail_text' do
      expect(mail_all.body.encoded).to match('Рассылка')
    end
  end

  # mail_all(business_role, current_user, text)

  context 'Mail all users of business_role and bproce`s owner' do
    it 'is sent email to bproce`s owner' do
      expect(mail.to[2]).to eq owner.email
    end
    it 'is sent email to business_role executors' do
      expect(mail.to[0]).to eq user1.email
      expect(mail.to[1]).to eq user2.email
    end
    it 'is having subject with business_role.name and bproce.id' do
      expect(mail.subject).to eq "BP1Step: изменилась роль [#{business_role.name}] в процессе ##{bproce.id}"
    end
    it 'is having sender`s name in the text' do
      expect(mail.body.encoded).to match(current_user.displayname)
    end
    it 'is having right text' do
      expect(mail.body.encoded).to match('Внесены изменения в действия роли')
    end
  end
end
