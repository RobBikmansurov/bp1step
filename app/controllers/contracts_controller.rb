class ContractsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_contract, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /contracts/1
  def show
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
    @contract.date_begin = Date.today
    @contract.status = "Проект"
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  def create
    @contract = Contract.new(contract_params)

    if @contract.save
      redirect_to @contract, notice: 'Contract was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /contracts/1
  def update
    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /contracts/1
  def destroy
    @contract.destroy
    redirect_to contracts_url, notice: 'Contract was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contract_params
      params.require(:contract).permit(:owner_id, :owner_name, :number, :name, :status, :date_begin, :date_end, :description, :text, :note)
    end

    def sort_column
      params[:sort] || "id"
    end

    def sort_direction
      params[:direction] || "asc"
    end


end
