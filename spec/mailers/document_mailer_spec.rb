# frozen_string_literal: true

require 'rails_helper'

describe DocumentMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:document) { FactoryBot.create(:document, owner_id: user.id) }

  describe 'file_not_found_email' do
    # рассылка об отсутствии файла документа
    let(:mail) { described_class.file_not_found_email(document, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: загрузить файл документа ##{document.id}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains document\'s name' do
      expect(mail.body.encoded).to match(document.name)
    end
    it '@text contains text' do
      expect(mail.body.encoded)
        .to match('К сожалению, к карточке данного документа не присоединен файл документа в электронном виде.')
    end
  end

  describe 'file_is_corrupted_email' do
    # рассылка о необходимости новой загрузки файла документа
    let(:mail) { described_class.file_is_corrupted_email(document, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: обновите файл документа ##{document.id}")
    end
    it '@text contains document\'s name' do
      expect(mail.body.encoded).to match(document.name)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('К сожалению, файл данного документа отсутствует или испорчен:')
    end
  end

  describe 'process_is_missing_email' do
    # рассылка о необходимости указания процесса для документа
    let(:mail) { described_class.process_is_missing_email(document, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: укажите процесс документа ##{document.id}")
    end
    it '@text contains document\'s name' do
      expect(mail.body.encoded).to match(document.name)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('Пожалуйста, укажите процессы, к которым относится данный документ.')
    end
  end

  describe 'check_documents_status' do
    # контроль статуса документов
    let(:mail) { described_class.check_documents_status(document, user.email, 'text') }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: статус документа ##{document.id}")
    end
    it '@text contains document\'s name' do
      expect(mail.body.encoded).to match(document.name)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('Пожалуйста, <strong>text</strong>.')
    end
  end
end
