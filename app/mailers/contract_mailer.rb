# frozen_string_literal: true

class ContractMailer < ActionMailer::Base
  default from: 'BP1Step <bp1step@bankperm.ru>'

  # рассылка ответственным об изменении договора или скана
  def update_contract(contract, current_user, scan, action)
    @contract = contract
    @scan = scan
    @action = action
    @current_user = current_user
    if @scan
      mail(to: addresses(contract),
           subject: "BP1Step: #{@action} файл договора ##{@contract.id}",
           template_name: 'update_contract_scan')
    else
      mail(to: addresses(contract),
           subject: "BP1Step: изменен договор ##{@contract.id}",
           template_name: 'update_contract')
    end
  end

  # рассылка о необходимости указания процесса для договора
  def process_is_missing_email(contract, user)
    @contract = contract
    @user = user
    mail(to: user.email, subject: "BP1Step: укажите процессы договора ##{@contract.id}")
  end

  # рассылка о просроченных договорах
  def check_outdated_contracts(contract, emails, text)
    @contract = contract
    @text = text
    mail(to: emails, subject: "BP1Step: #{@text} договор ##{@contract.id}")
  end

  # оповещение о договорах в статусе "Согласование"
  def check_contracts_status(contract, emails)
    @contract = contract
    mail(to: emails, subject: "BP1Step: согласование договора ##{@contract.id}")
  end

  private

  def addresses(contract)
    owner_email = contract.owner&.email
    payer_email = contract.payer&.email
    address = []
    address << owner_email if owner_email.present?
    address << payer_email if payer_email.present?
    # добавим в получатели Бардина для контроля
    address << 'bard@bankperm.ru' if contract.payer
    address
  end
end
