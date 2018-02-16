# frozen_string_literal: true

class ContractsController < ApplicationController
  respond_to :odt, only: :index
  respond_to :pdf, only: :show
  respond_to :html
  respond_to :xml, :json, only: %i[index show]
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit new]
  before_action :set_contract, only: %i[show edit update destroy new approval_sheet]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def autocomplete
    @contracts = Contract.order(:number).where('name ilike ? or number ilike ? or id = ?', "%#{params[:term]}%", "%#{params[:term]}%", params[:term].to_i.to_s)
    render json: @contracts.map(&:autoname)
  end

  def index
    @title_doc = 'Договоры'
    if params[:all].present?
      @contracts = Contract.all
    else
      if params[:bproce_id].present?
        @bproce = Bproce.find(params[:bproce_id])
        @contracts = @bproce.contracts.order(:status, :date_begin) # договоры процесса
        @title_doc = "Договоры процесса [ #{@bproce.shortname} ]"
      end
      if params[:status].present? # список договоров, имеющих конкретный статус
        @contracts = if @contracts.nil?
                       Contract.where(status: params[:status])
                     else
                       @contracts.where(status: params[:status])
                     end
        @title_doc += " статус [#{params[:status]}]"
      end
      if @contracts.nil?
        if params[:type].present? # список договоров, имеющих конкретный тип
          @contracts = Contract.where(contract_type: params[:type])
          @title_doc += ' тип [' + params[:type] + ']'
        elsif params[:place].present? # список договоров, хранящихся в конкретном месте
          if params[:place].empty?
            @contracts = Contract.where('contract_place = ""')
            @title_doc += ' место хранения оригинала [не указано]'
          else
            @contracts = Contract.where(contract_place: params[:place])
            @title_doc += ' место хранения оригинала [' + params[:place] + ']'
          end
        elsif params[:user].present? # список договоров, за которые отвечает пользователь
          @user = User.find(params[:user])
          @contracts = Contract.where(owner_id: params[:user])
          @title_doc += ' ответственный [' + @user.displayname + ']'
        elsif params[:payer].present? # список договоров, за оплату которых отвечает пользователь
          @user = User.find(params[:payer])
          @contracts = Contract.where(payer_id: params[:payer])
          @title_doc += ' ответственный за оплату [' + @user.displayname + ']'
        else
          @title_doc += ' поиск [' + params[:search] + ']' if params[':search'].present?
          @contracts = if sort_column == 'lft'
                         Contract.search(params[:search]).order(:lft).paginate(per_page: 10, page: params[:page])
                       else
                         Contract.search(params[:search])
                       end
        end
      end
    end
    respond_to do |format|
      format.html do
        @contracts = @contracts.includes(:agent).order(sort_column + ' ' + sort_direction)
                                                .paginate(per_page: 10, page: params[:page])
      end
      format.odt  { print }
      format.json { render json: @contracts }
      format.xml  { render xml: @contracts }
    end
  end

  def show
    @subcontracts = Contract.where('lft>? and rgt<?', @contract.lft, @contract.rgt).order('lft')
    respond_to do |format|
      format.html
      format.json { render json: @contract }
      format.xml { render xml: @contract }
    end
  end

  def new
    @contract.agent_id = params[:agent_id] if params[:agent_id].present?
    @contract.owner_id = current_user.id if user_signed_in?
    @contract.date_begin = Date.current
    @contract.status = 'Согласование'
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
        ContractMailer.update_contract(@contract, current_user, nil, '').deliver_now # оповестим ответственных об изменениях договора
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = 'Error sending mail to contract owner'
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
    @contract_scan = ContractScan.new
    @contract_scan.contract = @contract
    render :scan_create
  end

  def update_scan
    contract_scan = ContractScan.new(contract_scan_params) if params[:contract_scan].present?
    if contract_scan
      @contract = contract_scan.contract
      if contract_scan.name.blank?
        flash[:alert] = 'Ошибка - не указан комментарий для файла скана!'
      else
        flash[:notice] = 'Файл "' + contract_scan.name + '" загружен.' if contract_scan.save
        begin
          # оповестим ответственных об изменениях скана
          ContractMailer.update_contract(@contract, current_user, contract_scan, 'добавлен').deliver_now
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          flash[:alert] = 'Error sending mail to contract owner'
        end
      end
    else
      flash[:alert] = 'Ошибка - имя файла не указано.'
    end
    respond_with(contract_scan.contract)
  end

  def bproce_create
    @contract = Contract.find(params[:id])
    @bproce_contract = @contract.bproce_contract.new
    render :bproce_create
  end

  def clone
    contract = Contract.find(params[:id]) # договор - прототип
    @contract = Contract.new(status: 'Согласование', date_begin: Date.current)
    @contract.agent_id = contract.agent_id
    @contract.owner_id = current_user.id if user_signed_in?
    @contract.payer_id = contract.payer_id # ответственный за оплату
    @contract.contract_type = contract.contract_type
    @contract.description = contract.description
    @contract.name = contract.name
    @contract.number = contract.number
    @contract.number += '/1' if @contract.number.size < 19
    @contract.text = contract.text
    @contract.note = 'создан из #' + contract.id.to_s
    @contract.parent_id = contract.id
    if @contract.save
      flash[:notice] = "Successfully cloned Contract ##{contract.id}" if @contract.save
      contract.bproce_contract.find_each do |bp| # клонируем ссылки на процессы
        bproce_contract = BproceContract.new(contract_id: @contract, bproce_id: bp)
        bproce_contract.contract = @contract
        bproce_contract.bproce = bp.bproce
        bproce_contract.purpose = bp.purpose
        bproce_contract.save
      end
      @subcontracts = Contract.where('lft>? and rgt<?', @contract.lft, @contract.rgt).order('lft')
    else
      flash[:notice] = @contract.errors
      @subcontracts = Contract.where('lft>? and rgt<?', contract.lft, contract.rgt).order('lft')
    end
  end

  private

  def print
    report = ODFReport::Report.new('reports/contracts.odt') do |r|
      nn = 0 # порядковый номер документа
      nnp = 0
      first_part = 0 # номер раздела для сброса номера документа в разделе
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      @title_doc ||= ''
      @title_doc += '  стр.' + params[:page] if params[:page].present?
      r.add_field 'REPORT_TITLE', @title_doc
      r.add_table('TABLE_01', @contracts, header: true) do |t|
        t.add_column(:nn) do |_n1|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name) do |contract|
          d = if contract.date_begin
                ' от ' + contract.date_begin.strftime('%d.%m.%Y')
              else
                ' без даты'
              end
          "#{contract.contract_type} №#{contract.number} #{contract.name} #{d} #{contract.status}"
        end
        t.add_column(:agent, :agent_name)
        t.add_column(:id, :id)
        t.add_column(:description)
        t.add_column(:place, :contract_place)
        t.add_column(:responsible, :owner_name)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "contracts-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # Лист согласования
  def approval_sheet_odt
    report = ODFReport::Report.new('reports/approval-sheet-contract.odt') do |r|
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_field 'REPORT_DATE1', (Date.current + 10.days).strftime('%d.%m.%Y')
      r.add_field :id, @contract.id
      r.add_field :type, @contract.contract_type
      r.add_field :number, @contract.number
      r.add_field :name, @contract.name
      r.add_field :description, @contract.description
      r.add_field :owner, @contract.owner_name
      if @contract.parent
        parent = "к #{@contract.parent.contract_type} #{@contract.parent.shortname} [#{@contract.parent.status}]"
        parent += " от #{@contract.parent.date_begin.strftime('%d.%m.%Y')}" if @contract.parent.date_begin
      else
        parent = ''
      end
      r.add_field :parent, parent
      if @contract.agent
        if @contract.agent.town.present?
          r.add_field :agent, @contract.agent_name + ', г. ' + @contract.agent.town
        else
          r.add_field :agent, @contract.agent_name
        end
      else
        r.add_field :agent, 'Контрагент не выбран!'
      end
      rr = 0
      if @contract.bproce.present? # есть ссылки из документа на другие процессы?
        r.add_field :bp, 'Относится к процессам:'
        r.add_table('BPROCS', @contract.bproce_contract.all, header: false, skip_if_empty: true) do |t|
          t.add_column(:rr) do |_r1| # порядковый номер строки таблицы
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
        r.add_field :bp, 'Процесс не назначен!'
      end
      r.add_field :user_position, current_user.position.mb_chars.capitalize.to_s
      r.add_field :user_name, current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "c#{@contract.id}-approval-sheet.odt",
                               disposition: 'inline'
  end

  def set_contract
    if params[:search].present? # это поиск
      @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    elsif params[:id].present?
      @contract = Contract.find(params[:id])
    else
      @contract = Contract.new
    end
  end

  def contract_params
    params.require(:contract).permit(:owner_id, :owner_name, :payer_id, :payer_name, :number, :name, :status,
                                     :date_begin, :date_end, :description, :text, :note, :condition, :check,
                                     :agent_id, :agent_name, :parent_id, :parent_name, :contract_type, :contract_place)
  end

  def contract_scan_params
    params.require(:contract_scan).permit(:contract_id, :name, :scan)
  end

  def sort_column
    params[:sort] || 'lft'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, договор не найден'
    redirect_to action: :index
  end
end
