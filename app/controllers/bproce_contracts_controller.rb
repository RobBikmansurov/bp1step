# frozen_string_literal: true

class BproceContractsController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_action :authenticate_user!, only: %i[edit destroy]
  before_action :bproce_contract, except: %i[index show]

  def create
    flash[:notice] = 'Successfully created bproce_contract.' if @bproce_contract.save
    respond_with(@bproce_contract.contract)
  end

  def show
    @bproce_contract = BproceContract.find(params[:id])
    redirect_to(contract_path(@bproce_contract.contract_id)) && return
  end

  def destroy
    contract = @bproce_contract.contract
    if BproceContract.where(contract_id: contract.id).where.not(bproce_id: @bproce_contract.bproce_id).any?
      flash[:notice] = 'Договор удален из процесса.' if @bproce_contract.destroy
    else
      flash[:alert] = 'Отмена удаления: Договор должен ссылаться хотя бы на один процесс.'
    end
    if @bproce.present?
      respond_with(@bproce)
    else
      respond_with(contract)
    end
  end

  def edit
    respond_with(@bproce_contract)
  end

  def update
    flash[:notice] = 'Successfully updated bproce_contract.' if @bproce_contract.update(bproce_contract_params)
    respond_with(@bproce_contract)
  end

  private

  def bproce_contract
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @contract = Contract.find(params[:contract_id]) if params[:contract_id].present?
    @bproce_contract = params[:id].present? ? BproceContract.find(params[:id]) : BproceContract.new(bproce_contract_params)
  end

  def bproce_contract_params
    params.require(:bproce_contract).permit(:contract_id, :bproce_id, :bproce_name, :purpose)
  end
end
