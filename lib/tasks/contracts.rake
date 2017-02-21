# encoding: utf-8
# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
namespace :bp1step do
  desc 'Сontrol executed (outdated) contracts'
  task check_outdated_contracts: :environment do # проверить договоры с истекшим сроком окончания - запускается ежеддневно
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_outdated_contracts'
    outdated_contracts_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.where('date_end <= ?', Date.current).where(status: 'Действует').each do |contract| # просроченные договоры
      outdated_contracts_count += 1
      emails = u.email # DEBUG
      emails = contract.owner.email.to_s if contract.owner # ответственный за договор
      emails += ', ' + contract.payer.email.to_s if contract.payer
      ContractMailer.check_outdated_contracts(contract, emails, 'завершен').deliver
      logger.info "      ##{contract.id} \t#{emails}"
    end
    logger.info "      #{outdated_contracts_count} contracts is outdated"
  end

  desc 'Сontrol of expiring contracts'
  task check_expiring_contracts: :environment do # проверить договоры с истекашим сроком окончания - запускается по ПН
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_expiring_contracts'
    expiring_contracts_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.where('date_end BETWEEN ? AND ?', Date.current, Date.current + 8).where(status: 'Действует').each do |contract| # договоры со сроком действия -2 и + 7 дней от Пн
      expiring_contracts_count += 1
      emails = u.email # DEBUG
      emails = contract.owner.email.to_s if contract.owner # ответственный за договор
      emails += ', ' + contract.payer.email.to_s if contract.payer
      ContractMailer.check_outdated_contracts(contract, emails, 'прекращает').deliver
      logger.info "      ##{contract.id} \t#{emails}"
    end
    logger.info "      #{expiring_contracts_count} contracts is expiring from #{Date.current - 2} to #{Date.current + 7}"
  end

  desc 'Each contracts must have link to bproces'
  task check_bproce_contract_for_all_contracts: :environment do # проверить наличие процесса для каждого договора
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_bproce_contract_for_all_contracts'
    contract_count = 0
    wo_bproce_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.all.each do |contract| # все договоры
      contract_count += 1
      next unless contract.bproce_contract.count < 1 # есть процессы?
      # puts contract.id, contract.owner.displayname
      wo_bproce_count += 1
      mail_to = u # DEBUG
      mail_to = contract.owner if contract.owner # ответственный за договор
      ContractMailer.process_is_missing_email(contract, mail_to).deliver
      logger.info "      ##{contract.id} \t#{contract.owner.displayname}"
    end
    logger.info "      #{wo_bproce_count} contracts without processes from #{contract_count} contracts"
  end

  desc 'Check statuses of contracts'
  task check_contracts_status: :environment do # проверить договоры в статусе Согласование - запускается по ПН
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_contracts_status'
    contracts_count = 0
    u = User.find(97) # пользователь по умолчанию для оповещения
    Contract.where.not(status: 'Действует').where.not(status: 'НеДействует').each do |contract| # договоры в статусе "Согласование" или в странном статусе
      next unless contract.created_at < Date.current - 21 # даем три недели на согласование
      contracts_count += 1
      emails = u.email # DEBUG
      emails = contract.owner.email.to_s if contract.owner # ответственный за договор
      emails += ', ' + contract.payer.email.to_s if contract.payer
      ContractMailer.check_contracts_status(contract, emails).deliver
      logger.info "      ##{contract.id} \t#{emails} \t#{contract.status} \t#{contract.date_begin.strftime('%d.%m.%Y')}"
    end
    logger.info "      #{contracts_count} contracts are in status = Approval"
  end
end
# rubocop:enable
