# coding: utf-8
class ContractsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :approval_sheet]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  respond_to :html, :xml, :json, :js
  autocomplete :bproce, :name, :extra_data => [:id]

  def autocomplete
    @contracts = Contract.order(:number).where("name ilike ? or number ilike ?", "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @contracts.map(&:autoname)
  end

  def index
    if params[:status].present? #  список договоров, имеющих конкретный статус
      @contracts = Contract.where(:status => params[:status]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      if params[:type].present? #  список договоров, имеющих конкретный тип
        @contracts = Contract.where(:contract_type => params[:type]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        if params[:place].present? #  список договоров, хранящихся в конкретном месте
          @contracts = Contract.where(:contract_place => params[:place]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        else
          if sort_column == 'lft'
            @contracts = Contract.search(params[:search]).order(:lft).paginate(:per_page => 10, :page => params[:page])
          else
            @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
          end
        end
      end
    end
  end

  def show
    @subcontracts = Contract.where("lft>? and rgt<?", @contract.lft, @contract.rgt).order("lft")
  end

  def new
    @contract = Contract.new
    @contract.agent_id = params[:agent_id] if params[:agent_id].present?
    @contract.owner_id = current_user.id if user_signed_in?
    @contract.date_begin = Date.today
    @contract.status = "Согласование"
    @contract.contract_type = 'Договор'
  end

  def edit
    @bproce_contract = @contract.bproce_contract.new # заготовка для новой связи с процессом
  end

  def create
    @contract = Contract.new(contract_params)

    if @contract.save
      redirect_to @contract, notice: 'Contract was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @contract.destroy
    redirect_to contracts_url, notice: 'Contract was successfully destroyed.'
  end

  def approval_sheet
      approval_sheet_odt
  end

  def scan_create
    @contract = Contract.find(params[:id])
    @contract_scan = ContractScan.new()
    @contract_scan.contract = @contract
    render :scan_create
  end

  def update_scan
    #@contract = Contract.find(params[:id]) if params[:id].present?
    contract_scan = ContractScan.new(params[:contract_scan]) if params[:contract_scan].present?
    if contract_scan
      flash[:notice] = 'Файл "' + contract_scan.name  + '" загружен.' if contract_scan.save
    else      
      flash[:alert] = "Ошибка - имя файла не указано."
    end
    respond_with(contract_scan.contract)
  end

  private

    def approval_sheet_odt    # Лист согласования
      report = ODFReport::Report.new("reports/approval-sheet-contract.odt") do |r|
        r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
        r.add_field "REPORT_DATE1", (Date.today + 10.days).strftime('%d.%m.%Y')
        r.add_field :id, @contract.id
        r.add_field :type, @contract.contract_type
        r.add_field :number, @contract.number
        r.add_field :name, @contract.name
        r.add_field :description, @contract.description
        r.add_field :owner, @contract.owner_name
        if @contract.agent
          if !@contract.agent.town.blank?
            r.add_field :agent, @contract.agent_name + ', г. ' + @contract.agent.town
          else
            r.add_field :agent, @contract.agent_name
          end
        else
          r.add_field :agent, "Контрагент не выбран!"
        end
        rr = 0
        if !@contract.bproce.blank?  # есть ссылки из документа на другие процессы?
          r.add_field :bp, "Относится к процессам:"
          r.add_table("BPROCS", @contract.bproce_contract.all, :header => false, :skip_if_empty => true) do |t|
            t.add_column(:rr) do |n1| # порядковый номер строки таблицы
              rr += 1
            end
            t.add_column(:process_name) do |bp|
              bp.bproce.name
            end
            t.add_column(:process_id) do |bp|
              bp.bproce.id
            end
            t.add_column(:process_owner) do |bp|
              bp.bproce.user_name
            end
          end
        else
          r.add_field :bp, "Процесс не назначен!"
        end
        #r.add_field "ORDERNUM", Date.today.strftime('%Y%m%d-с') + @usr.id.to_s
        #r.add_field :displayname, @usr.displayname
        r.add_field :user_position, current_user.position
        r.add_field "USER_NAME", current_user.displayname
      end
      send_data report.generate, type: 'application/msword',
        :filename => "approval-sheet.odt",
        :disposition => 'inline'
    end

    def set_contract
      @contract = Contract.find(params[:id])
    end

    def contract_params
      params.require(:contract).permit(:owner_id, :owner_name, :number, :name, :status, :date_begin, :date_end, :description, :text, :note, :condition, :check, :agent_id, :agent_name, :parent_id, :parent_name, :contract_type, :contract_place)
    end

    def contract__scan_params
      params.require(:contract_scan).permit(:conntract_id, :name)
    end

    def sort_column
      params[:sort] || "lft"
    end

    def sort_direction
      params[:direction] || "asc"
    end

  def record_not_found
    flash[:alert] = "Неверный #id, Договор не найден."
    redirect_to action: :index
  end


end
