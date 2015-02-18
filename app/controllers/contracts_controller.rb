# coding: utf-8
class ContractsController < ApplicationController
  respond_to :odt, :only => :index
  respond_to :pdf, :only => :show
  respond_to :html, :xml, :json
  respond_to :xml, :json, :only => [:index, :show]
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :new]
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :new, :approval_sheet]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  autocomplete :bproce, :name, :extra_data => [:id]

  def autocomplete
    @contracts = Contract.order(:number).where("name ilike ? or number ilike ?", "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @contracts.map(&:autoname)
  end

  def index
    if params[:status].present? #  список договоров, имеющих конкретный статус
      #@contracts = Contract.where(:status => params[:status]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      @contracts = Contract.where(:status => params[:status])
      @title_doc = 'статус [' + params[:status] + ']'
    else
      if params[:type].present? #  список договоров, имеющих конкретный тип
        @contracts = Contract.where(:contract_type => params[:type])
        @title_doc = 'тип [' + params[:type] + ']'
      else
        if params[:place].present? #  список договоров, хранящихся в конкретном месте
          if params[:place].size == 0
            @contracts = Contract.where("contract_place = ''")
            @title_doc = 'место хранения оригинала [не указано]'
          else
            @contracts = Contract.where(:contract_place => params[:place])
            @title_doc = 'место хранения оригинала [' + params[:place] + ']'
          end
        else
          if params[:user].present? #  список договоров, за которые отвечает пользователь
            @user = User.find(params[:user])
            @contracts = Contract.where(:owner_id => params[:user])
            @title_doc = 'ответственный [' + @user.displayname + ']'
          else
            if params[:payer].present? #  список договоров, за оплату которых отвечает пользователь
              @user = User.find(params[:payer])
              @contracts = Contract.where(:payer_id => params[:payer])
              @title_doc = 'ответственный за оплату [' + @user.displayname + ']'
            else
              @title_doc = 'поиск [' + params[:search] + ']' if params[':search'].present?
              if sort_column == 'lft'
                @contracts = Contract.search(params[:search]).order(:lft).paginate(:per_page => 10, :page => params[:page])
              else
                @contracts = Contract.search(params[:search])
              end
            end
          end
        end
      end
    end
    respond_to do |format|
      format.html {
        @contracts = @contracts.order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      }
      format.odt { print  }
      format.json { render json: @contracts }
      format.xml { render xml: @contracts }
    end  end

  def show
    @subcontracts = Contract.where("lft>? and rgt<?", @contract.lft, @contract.rgt).order("lft")
    respond_to do |format|
      format.html
      format.json { render json: @contract }
      format.xml { render xml: @contract }
    end
  end

  def new
    @contract.agent_id = params[:agent_id] if params[:agent_id].present?
    @contract.owner_id = current_user.id if user_signed_in?
    @contract.date_begin = Date.today
    @contract.status = "Согласование"
    @contract.contract_type = 'Договор'
  end

  def edit
    @bproce_contract = @contract.bproce_contract.new # заготовка для новой связи с процессом
    respond_with(@contract)
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
      begin
        ContractMailer.update_contract(@contract, current_user).deliver    # оповестим ответсвенных об изменениях договора
      rescue  Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to contract owner"
      end
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

  def bproce_create
    @contract = Contract.find(params[:id])
    @bproce_contract = @contract.bproce_contract.new
    #@contract_scan.contract = @contract
    render :bproce_create
  end

  def clone
    contract = Contract.find(params[:id])   # договор - прототип
    @contract = Contract.new()
    @contract.agent_id = contract.agent_id
    @contract.owner_id = current_user.id if user_signed_in?
    @contract.date_begin = Date.today
    @contract.status = "Согласование"
    @contract.contract_type = contract.contract_type
    @contract.description = contract.description
    @contract.name = contract.name
    @contract.number = contract.number + "/1"
    @contract.text = contract.text
    @contract.note = 'создан из #' + contract.id.to_s
    @contract.parent_id = contract.id
    if @contract.save
      flash[:notice] = "Successfully cloned Contract ##{contract.id}" if @contract.save
      contract.bproce_contract.each do |bp|     # клонируем ссылки на процессы
        bproce_contract = BproceContract.new(contract_id: @contract, bproce_id: bp)
        bproce_contract.contract = @contract
        bproce_contract.bproce = bp.bproce
        bproce_contract.purpose = bp.purpose
        bproce_contract.save
      end
      @subcontracts = Contract.where("lft>? and rgt<?", @contract.lft, @contract.rgt).order("lft")
    else
      flash[:notice] = @contract.errors
      @subcontracts = Contract.where("lft>? and rgt<?", contract.lft, contract.rgt).order("lft")
    end
  end

  private

  def print
    report = ODFReport::Report.new("reports/contracts.odt") do |r|
      nn = 0  # порядковый номер документа
      nnp = 0
      first_part = 0  # номер раздела для сброса номера документа в разделе
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      @title_doc = '' if !@title_doc
      if params[:page].present?
        #@title_doc = @title_doc + '  стр.' + params[:page]
      end
      r.add_field "REPORT_TITLE", @title_doc
      r.add_table("TABLE_01", @contracts, :header => true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name) do |contract|
          if contract.date_begin
            d = ' от ' + contract.date_begin.strftime('%d.%m.%Y')
          else
            d = ' без даты'
          end
          s = contract.contract_type + ' №' + contract.number + ' ' + contract.name + d + ' ' + contract.status
          "#{s}"
        end
        t.add_column(:agent, :agent_name)
        t.add_column(:id, :id)
        t.add_column(:description)
        t.add_column(:place, :contract_place)
        t.add_column(:responsible, :owner_name)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      filename: "documents.odt",
      disposition: 'inline'
  end

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
      if params[:search].present? # это поиск
        @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        render :index # покажем список найденного
      else
        if params[:id].present?
          @contract = Contract.find(params[:id])
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
