class BproceContractsController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :authenticate_user!, :only => [:edit, :new, :destroy]
  before_filter :get_bproce_contract, :except => [ :index, :show ]
  
  def new
    @contract = Contract.find(params[:contract_id])
    @contract_bproce = @contract.bproce_contract.new # заготовка для новой связи с процессом
    respond_to do |format|
      format.html { render 'new' } # view.html.erb
      format.js { } # view.js.erb
    end
  end

  def create
    #@bproce_contract = Bprocecontract.create(params[:bproce_contract])
    flash[:notice] = "Successfully created bproce_contract." if @bproce_contract.save
    respond_with(@bproce_contract.contract)
  end

  def show
    @bproce_contract = BproceContract.find(params[:id])
    @bproce = Bproce.find(@bproce_contract.bproce_id)
    respond_with(@bproce_contracts = @bproce.bproce_contracts)
  end

  def destroy
    contract = @bproce_contract.contract
    if contract.bproce.count > 1
      flash[:notice] = "Successfully destroyed bproce_contract." if @bproce_contract.destroy
    else
      flash[:alert] = "Error destroyed bproce_contract."
    end
    if !@bproce.blank?
      respond_with(@bproce)
    else
      respond_with(contract)
    end
  end

  def edit
    respond_with(@bproce_contract)
  end

  def update
    flash[:notice] = "Successfully updated bproce_contract." if @bproce_contract.update_attributes(params[:bproce_contract])
    respond_with(@bproce_contract)
  end


private

  def get_bproce_contract
    @bproce = Bproce.find(params[:bproce_id]) if params[:bproce_id].present?
    @contract = Contract.find(params[:contract_id]) if params[:contract_id].present?
    @bproce_contract = params[:id].present? ? BproceContract.find(params[:id]) : BproceContract.new(params[:bproce_contract])
  end


end