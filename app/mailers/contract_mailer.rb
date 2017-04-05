# frozen_string_literal: true

class ContractMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка ответственным об изменении договора или скана
  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
  def update_contract(contract, current_user, scan, action)
    @contract = contract
    @scan = scan
    @action = action
    owner_email = @contract.owner&.email # ответственный за договор
    payer_email = @contract.payer&.email # ответственный за оплату договора
    address = []
    address << owner_email if owner_email.present?
    address << payer_email if payer_email.present?
    address << 'bard@bankperm.ru' if @contract.payer # добавим в получатели Бардина для контроля
    @current_user = current_user
    if @scan
      mail(to: address.join(', '),
           subject: "BP1Step: #{@action} файл договора ##{@contract.id}",
           template_name: 'update_contract_scan')
    else
      mail(to: address,
           subject: "BP1Step: изменен договор ##{@contract.id}",
           template_name: 'update_contract')
    end
  end

  def process_is_missing_email(contract, user)	# рассылка о необходимости указания процесса для договора
    @contract = contract
    @user = user
    mail(to: user.email, subject: "BP1Step: укажите процессы договора ##{@contract.id}")
  end

  def check_outdated_contracts(contract, emails, text) # рассылка о просроченных договорах
    @contract = contract
    @text = text
    mail(to: emails, subject: "BP1Step: #{@text} договор ##{@contract.id}")
  end

  def check_contracts_status(contract, emails) # оповещение о договорах в статусе "Согласование"
    @contract = contract
    mail(to: emails, subject: "BP1Step: согласование договора ##{@contract.id}")
  end
end
