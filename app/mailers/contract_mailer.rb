# coding: utf-8
class ContractMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def update_contract(contract, current_user, scan, action)   # рассылка ответственным об изменении договора или скана
    @contract = contract
    @scan = scan
    @action = action
    address = @contract.owner.email if @contract.owner.email  # ответственный за договор
    if @contract.payer
      address.concat(', ' + @contract.payer.email.to_s) if !@contract.payer.email.empty?  # отвественный за оплату договора
      address.concat(', bard@bankperm.ru')  # добавим в получатели Бардина для контроля
    end
    @current_user = current_user
    if @scan
      mail(to: address, 
           subject: "BP1Step: #{@action} файл договора ##{@contract.id.to_s}",
           template_name: "update_contract_scan")
    else
      mail(to: address,
           subject: "BP1Step: изменен договор ##{@contract.id.to_s}",
           template_name: "update_contract")
    end
  end

  def process_is_missing_email(contract, user)		# рассылка о необходимости указания процесса для договора
    @contract = contract
    @user = user
    mail(:to => user.email, :subject => "BP1Step: укажите процессы договора ##{@contract.id.to_s}")
  end

  def check_outdated_contracts(contract, emails, text)   # рассылка о просроченных договорах
    @contract = contract
    @text = text
    mail(:to => emails, :subject => "BP1Step: #{@text} договор ##{@contract.id.to_s}")
  end

  def check_contracts_status(contract, emails)  # оповещение о договорах в статусе "Согласование"
    @contract = contract
    mail(:to => emails, :subject => "BP1Step: согласование договора ##{@contract.id.to_s}")
  end
  
end
