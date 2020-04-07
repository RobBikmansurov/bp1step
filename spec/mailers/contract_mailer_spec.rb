# frozen_string_literal: true

require 'rails_helper'

describe ContractMailer do
  let!(:owner) { FactoryBot.create :user }
  let!(:payer) { FactoryBot.create :user }
  let(:contract) { FactoryBot.create(:contract, owner_id: owner.id, payer_id: payer.id) }
  let!(:action) { 'изменен' }

  describe 'update_contract - file scan changed' do
    let!(:scan) { FactoryBot.create :contract_scan, contract_id: contract.id }
    let(:mail) { described_class.update_contract(contract, owner, scan, action) }

    it 'sends an email' do
      # expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: #{action} файл договора ##{contract.id}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email, payer.email, 'bard@bankperm.ru'])
    end

    it 'text contains contract\'s scan file name' do
      expect(mail.body.encoded).to match(scan.scan_file_name)
    end
  end

  describe 'update_contract - contract changed' do
    let(:mail) { described_class.update_contract(contract, owner, nil, action) }

    it 'sends an email' do
      # expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: #{action} договор ##{contract.id}")
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email, payer.email, 'bard@bankperm.ru'])
    end

    it 'text contains contract\'s description' do
      expect(mail.body.encoded).to match(contract.description)
    end
  end

  describe 'process_is_missing_email' do
    # process_is_missing_email(contract, user) рассылка о необходимости указания процесса для договора
    let(:mail) { described_class.process_is_missing_email(contract, owner) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: укажите процессы договора ##{contract.id}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end
  end

  describe 'check_outdated_contracts' do
    # check_outdated_contracts(contract, emails, text) рассылка о просроченных договорах
    let(:text) { 'text' }
    let(:mail) { described_class.check_outdated_contracts(contract, [owner.email, payer.email], text) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: #{text} договор ##{contract.id}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email, payer.email])
    end

    it 'text contains contract\'s description' do
      expect(mail.body.encoded).to match(contract.description)
    end

    it 'text contains contract\'s agent name' do
      expect(mail.body.encoded).to match(contract.agent.name)
    end
  end

  describe 'check_contracts_status' do
    # check_contracts_status(contract, emails) # оповещение о договорах в статусе "Согласование"
    let(:mail) { described_class.check_contracts_status(contract, [owner.email]) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: согласование договора ##{contract.id}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'text contains contract\'s description' do
      expect(mail.body.encoded).to match(contract.description)
    end

    it 'text contains contract\'s agent name' do
      expect(mail.body.encoded).to match(contract.agent.name)
    end
  end

  describe 'addresses' do
    let!(:contract) { create :contract, owner_id: owner.id, payer_id: payer.id }

    it 'return array with owner`s and payer`s emails' do
      obj = described_class.new
      addresses = obj.send(:addresses, contract)
      expect(addresses).to eql([owner.email, payer.email, 'bard@bankperm.ru'])
    end
  end
end
