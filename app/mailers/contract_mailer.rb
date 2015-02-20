# coding: utf-8
class ContractMailer < ActionMailer::Base
  default from: "BP1Step <bp1step@bankperm.ru>"

  def update_contract(contract, current_user)   # рассылка ответственным об изменении договора
    @contract = contract
    address = @contract.owner.email if @contract.owner.email  # ответственный за договор
    if @contract.payer
      address.concat(', ' + @contract.payer.email.to_s) if !@contract.payer.email.empty?  # отвественный за оплату договора
    end
    @current_user = current_user
    mail(:to => address, :subject => "BP1Step: изменен договор ##{@contract.id.to_s}")
  end

  def process_is_missing_email(contract , user)		# рассылка о необходимости указания процесса для договора
    @contract = contract
    @user = user
    mail(:to => user.email, :subject => "BP1Step: укажите процессы договора ##{@contract.id.to_s}")
  end

end
