# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessRoleMailer, type: :mailer do
  let(:owner) { create :user }
  let(:bproce) { create :bproce, user_id: owner.id }
  let(:business_role) { create :business_role, bproce_id: bproce.id }
  let(:current_user) { create :user }
  let(:user1) { create :user, active: true }
  let(:user2) { create :user, active: true }
  # rubocop:disable RSpec/LetSetup
  let!(:user_business_role1) { create :user_business_role, business_role_id: business_role.id, user_id: user1.id }
  let!(:user_business_role2) { create :user_business_role, business_role_id: business_role.id, user_id: user2.id }
  # rubocop:enable RSpec/LetSetup

  let(:mail_all) { BusinessRoleMailer.mail_all(business_role, current_user, 'Рассылка') }
  let(:mail) { BusinessRoleMailer.update_business_role(business_role, current_user) }

  context 'when sends mail to all users of business_role' do
    it 'sent email to owner and all executors' do
      expect(mail_all.to).to eq [user1.email, user2.email, owner.email]
    end
    it 'mail having subject with business_role.name and bproce.id' do
      expect(mail_all.subject).to eq "BP1Step: рассылка исполнителям [#{business_role.name}] в процессе ##{bproce.id}"
    end
    it 'mail having sender`s name in the text' do
      expect(mail_all.body.encoded).to match(current_user.displayname)
    end
    it 'mail having text of the mail_text' do
      expect(mail_all.body.encoded).to match('Рассылка')
    end
  end

  context 'when changed business_role' do
    it 'sent email to owner and to all executors' do
      expect(mail.to).to eq([user1.email, user2.email, owner.email])
    end
    it 'having subject with business_role.name and bproce.id' do
      expect(mail.subject).to eq "BP1Step: изменилась роль [#{business_role.name}] в процессе ##{bproce.id}"
    end
    it 'having sender`s name in the text' do
      expect(mail.body.encoded).to match(current_user.displayname)
    end
    it 'having right text' do
      expect(mail.body.encoded).to match('Внесены изменения в действия роли')
    end
  end
end
