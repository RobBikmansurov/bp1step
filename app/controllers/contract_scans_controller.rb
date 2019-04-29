# frozen_string_literal: true

class ContractScansController < ApplicationController
  respond_to :html
  before_action :authenticate_user!, only: %i[edit new]
  before_action :set_contract_scan, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def edit
    @contract = @contract_scan.contract if @contract_scan
  end

  def update
    @contract = @contract_scan.contract if @contract_scan
    if @contract_scan.update(contract_scan_params)
      redirect_to @contract, notice: 'Contract_scan name was successfully updated.'
      begin
        ContractMailer.update_contract(@contract, current_user, @contract_scan, 'изменен').deliver # оповестим ответственных об изменениях договора
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = 'Error sending mail to contract owner'
      end
    else
      render action: 'edit'
    end
  end

  def destroy
    @contract = @contract_scan.contract if @contract_scan
    if @contract_scan.destroy
      begin
        ContractMailer.update_contract(@contract, current_user, @contract_scan, 'удален').deliver # оповестим ответственных об удалении файла договора
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = 'Error sending mail to contract owner'
      end
    end
    redirect_to contract_url(@contract), notice: 'Contract_scan was successfully destroyed.'
  end

  private

  def set_contract_scan
    if params[:id].present?
      @contract_scan = ContractScan.find(params[:id])
    else
      @contract = Contract.new
    end
  end

  def contract_scan_params
    params.require(:contract_scan).permit(:contract_id, :name)
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, Скан договора не найден.'
    redirect_to action: :index
  end
end
