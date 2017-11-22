# frozen_string_literal: true

require 'rails_helper'

# DocumentMailer.check_documents_status(document, emails, 'установите статус').deliver_now

describe DocumentMailer do
  describe 'check_documents_status' do
    let(:owner)    { FactoryBot.create(:user) }
    let(:document) { FactoryBot.create(:document, id: 100, owner: owner) }
    let(:user)     { FactoryBot.create(:user) }
    let(:mail)     { DocumentMailer.check_documents_status(document, [user.email], 'установите статус') }

    it 'renders the subject' do
      expect(mail.subject).to eql('BP1Step: статус документа #100')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'assigns @text' do
      expect(mail.body.encoded).to match('установите статус')
      # expect(mail.body.encoded).to match(user.name)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded).to match("http://localhost:3000/documents/#{document.id}")
    end
  end
end
