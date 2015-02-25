# coding: utf-8
class ContractScansController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:edit, :new]
  before_action :set_contract_scan, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def set_contract_scan
      if params[:search].present? # это поиск
        @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        render :index # покажем список найденного
      else
        if params[:id].present?
          @contract_scan = ContractScan.find(params[:id])
        else
          @contract = Contract.new
        end
      end
    end

    def contract_params
      params.require(:contract).permit(:owner_id, :owner_name, :payer_id, :payer_name, :number, :name, :status, :date_begin, :date_end, :description, :text, :note, :condition, :check, :agent_id, :agent_name, :parent_id, :parent_name, :contract_type, :contract_place)
    end

    def contract__scan_params
      params.require(:contract_scan).permit(:conntract_id, :name)
    end

    def record_not_found
      flash[:alert] = "Неверный #id, Скан договора не найден."
      redirect_to action: :index
    end

end
