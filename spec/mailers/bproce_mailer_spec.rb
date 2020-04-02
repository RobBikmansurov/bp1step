# frozen_string_literal: true

require 'rails_helper'

describe BproceMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:bproce) { FactoryBot.create(:bproce, user_id: user.id) } # , author_id: user.id) }

  describe 'process_without_roles' do
    # # рассылка об отстутствии ролей в процессе
    let(:mail) { described_class.process_without_roles(bproce, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: не выделены роли в процессе ##{bproce.id}")
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
      expect(mail.body.encoded).to match('не выделены роли')
    end
  end
end
