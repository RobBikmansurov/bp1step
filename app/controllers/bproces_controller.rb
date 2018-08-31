# frozen_string_literal: true

class BprocesController < ApplicationController
  include TheSortableTreeController::Rebuild

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # caches_page :show, :new

  respond_to :html
  respond_to :pdf, :xml, :json, only: %i[index list]
  helper_method :sort_column, :sort_direction
  before_action :get_bproce, except: %i[index list manage autocomplete]
  before_action :authenticate_user!, only: %i[edit new create update]

  # плоский список процессов без дерева
  def list
    @bproces = Bproce.search('?', params[:search]).order(sort_order(sort_column, sort_direction)).find(:all, include: :user)
    respond_to do |format|
      format.html
      format.pdf { print_list }
    end
  end

  def index
    if params[:all].present?
      @bproces = Bproce.nested_set
    elsif params[:tag].present?
      @bproces = Bproce.nested_set.tagged_with(params[:tag]).search__by_all_column(params[:search])
    elsif params[:user].present? #  список процессов пользователя
      @user = User.find(params[:user])
      @bproces = Bproce.nested_set.where(user_id: params[:user])
    else
      @bproces = if params[:search].present?
                   Bproce.nested_set.search__by_all_column(params[:search])
                 else
                   Bproce.nested_set
                 end
    end
    @bproces = @bproces.order(:lft)
    respond_to do |format|
      format.html
      format.pdf { print }
    end
  end

  def autocomplete
    @bproces = Bproce.order(:name)
                     .where('id = ? or name ilike ? or shortname ilike ? ',
                            params[:term].to_i.to_s, "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @bproces.map(&:name)
  end

  def show
    @metrics = Metric.where(bproce_id: @bproce.id).order(:name) if @bproce # метрики процесса
    @directive_of_bproce = Directive.last&.directives_of_bproce(@bproce.id) if @bproce
    respond_with(@bproce)
  end

  def card
    print_card # карточка процесса
  end

  def check_list
    print_check_list # чек-лист карточки процесса
  end

  def check_list_improve
    print_check_list_improve # чек-лист карточки улучшения процесса
  end

  def doc
    print_doc # заготовка описания процесса
  end

  def order
    print_order # распоряжение о назначении исполнителей на роли в процессе
  end

  def new_sub_process
    @parent = @bproce
    @bproce = Bproce.new(parent_id: @parent.id)
    respond_with(@bproce)
  end

  def edit
    @business_role = BusinessRole.new(bproce_id: @bproce.id)
    @document = Document.new(bproce_id: @bproce.id) # заготовка для нового документа
    @subproce = Bproce.new(parent_id: @bproce.id) # заготовка для подпроцесса
    @bproce_bapp = BproceBapp.new(bproce_id: @bproce.id) # заготовка для нового приложения
    @bproce_workplace = BproceWorkplace.new(bproce_id: @bproce.id)  # заготовка для нового рабочего места
    @bproce_iresource = BproceIresource.new(bproce_id: @bproce.id)  # заготовка для нового ресурса
    @parent = @bproce.parent if @bproce.parent_id # родительский процесс
  end

  def create
    @bproce = Bproce.new(bproce_params)
    if @bproce.save
      redirect_to @bproce, notice: 'SubProcess was successfully created.'
    else
      render action: 'new_sub_process'
    end
  end

  def update
    if params[:business_role].present?
      @business_role = Role.new(params[:business_role])
      @business_role&.save
    end
    if params[:document].present?
      @document = Document.new(params[:document])
      @document&.save
    end
    @bproce = Bproce.find(params[:id])
    if @bproce.update(bproce_params)
      redirect_to @bproce, notice: 'Successfully updated Bproce.'
    else
      render action: 'edit'
    end
  end

  def destroy
    flash[:notice] = 'Successfully destroyed Bproce.' if @bproce.destroy
    redirect_to bproces_path
  end

  def manage
    @bproces = Bproce.nested_set.select('id, shortname, name as title, parent_id').all
    # @bproces = Bproce.nested_set.roots.select('id, shortname, name as title, parent_id').all
  end

  def metrics
    @metrics = Metric.where(bproce_id: @bproce.id).order(:name) # метрики процесса
    respond_with(@bproce)
  end

  def new_metric
    @metric = Metric.new
    @metric.bproce_id = @bproce_id
    @metric.depth = 3
  end

  private

  def bproce_params
    params.require(:bproce).permit(:name, :shortname, :fullname, :goal,
                                   :parent_id, :parent_name_form,
                                   :user_id, :user_name_form, :user_name,
                                   :checked_at, :description)
  end

  def sort_column
    params[:sort] || 'lft'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def get_bproce
    if params[:search].present? # это поиск
      @bproces = Bproce.search__by_all_column(params[:search])
      render :index # покажем список найденного
    else
      @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
    end
  end

  def record_not_found
    flash[:alert] = 'Требуемый Процесс не найден.'
    redirect_to action: :index
  end

  def print
    report = ODFReport::Report.new('reports/bprocess.odt') do |r|
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      nn = 0 # порядковый номер строки
      r.add_table('TABLE_01', @bproces, header: true) do |t|
        t.add_column(:nn) { |_ca| nn += 1 } # порядковый номер строки таблицы
        t.add_column(:owner) { |bproce| bproce.user&.displayname } # владелец процесса, если задан
        t.add_column(:name) { |bp| '__' * bp.depth } # уровень вложенности процессов вместо наименования
        t.add_column(:fullname)
        t.add_column(:id)
        t.add_column(:goal)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "processes-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # печать Карточки процесса
  def print_card
    report = ODFReport::Report.new('reports/bp-card.odt') do |r|
      form_report_header(r)
      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where('lft>? and rgt<?', @bproce.lft, @bproce.rgt).order('lft') # все подпроцессы процесса
      if subs.any? # если подпроцессов нет - пустая таблица не будет выведена
        r.add_table('SUBPROC', subs, header: false, skip_if_empty: true) do |t|
          t.add_column(:sp) { |_ca| sp += 1 } # порядковый номер строки таблицы
          t.add_column(:spname) { |sub| '__' * (sub.depth - @bproce.depth) + " [#{sub.shortname}] #{sub.name}" }
          t.add_column(:sp_id, &:id)
          t.add_column(:spowner) { |sp| sp.user&.displayname }
        end
      end
      @metrics = Metric.where(bproce_id: @bproce.id).order(:name) # метрики процесса
      report_metrics(@metrics, r, false) # сформировать список метрик процесса
      ids = BproceDocument.where(bproce_id: @bproce.id).pluck :document_id
      report_docs(Document.where(id: ids).active, r, false) # сформировать таблицу действующих документов процесса
      report_contracts(@bproce.contracts.active, r, false) # сформировать список договоров
      report_roles(@bproce.business_roles, r, true) # сформировать таблицу ролей
      report_workplaces(@bproce, r, true) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, true) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, true) # сформировать таблицу ресурсов процесса

      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "#{@bproce.id}-card-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # печатать чек-лист Карточки процесса
  def print_check_list
    report = ODFReport::Report.new('reports/bp-check.odt') do |r|
      form_report_header(r)
      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where('lft>? and rgt<?', @bproce.lft, @bproce.rgt).order('lft') # все подпроцессы процесса
      if subs.any? # если подпроцессов нет - пустая таблица не будет выведена
        r.add_table('SUBPROC', subs, header: false, skip_if_empty: true) do |t|
          t.add_column(:sp) { |_ca| sp += 1 } # порядковый номер строки таблицы
          t.add_column(:spname) { |sub| '__' * (sub.depth - @bproce.depth) + " [#{sub.shortname}] #{sub.name}" }
          t.add_column(:sp_id, &:id)
          t.add_column(:spowner) { |sp| sp.user&.displayname }
        end
      end
      roles = if @bproce.business_roles.any?
                @bproce.business_roles.collect(&:name).join(', ')
              else
                'Роли не выделены!' # сформировать список ролей
              end
      r.add_field 'ROLES', roles
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "#{@bproce.id}-check_list-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # печатать чек-лист Улучшения процесса
  def print_check_list_improve
    report = ODFReport::Report.new('reports/bp-check-improve.odt') do |r|
      form_report_header(r)
      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where('lft>? and rgt<?', @bproce.lft, @bproce.rgt).order('lft') # все подпроцессы процесса
      if subs.any? # если подпроцессов нет - пустая таблица не будет выведена
        r.add_table('SUBPROC', subs, header: false, skip_if_empty: true) do |t|
          t.add_column(:sp) { |_ca| sp += 1 } # порядковый номер строки таблицы
          t.add_column(:spname) { |sub| '__' * (sub.depth - @bproce.depth) + " [#{sub.shortname}] #{sub.name}" }
          t.add_column(:sp_id, &:id)
          t.add_column(:spowner) { |sp| sp.user&.displayname }
        end
      end
      roles = if @bproce.business_roles.any?
                @bproce.business_roles.collect(&:name).join(', ') # сформировать список ролей
              else
                'Роли не выделены!'
              end
      r.add_field 'ROLES', roles
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "#{@bproce.id}-check_list-improve-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # заготовка описания процесса
  def print_doc
    report = ODFReport::Report.new('reports/bp-doc.odt') do |r|
      form_report_header(r)
      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where('lft>? and rgt<?', @bproce.lft, @bproce.rgt).order('lft') # все подпроцессы процесса
      r.add_table('SUBPROC', subs, header: false, skip_if_empty: true) do |t|
        if subs.any? # если документов нет - пустая таблица не будет выведена
          r.add_field :sub_process, 'В процесс входят следующие подпроцессы:'
          t.add_column(:sp) { |_ca| sp += 1 } # порядковый номер строки таблицы
          t.add_column(:spname) { |sub| '__' * (sub.depth - @bproce.depth) + sub.name }
          t.add_column(:sp_id, &:id)
        else
          r.add_field :sub_process, 'Подпроцессов нет.'
        end
      end

      @metrics = Metric.where(bproce_id: @bproce.id).order(:name) # метрики процесса
      report_metrics(@metrics, r, false) # сформировать список метрик процесса
      ids = BproceDocument.where(bproce_id: @bproce.id).pluck :document_id
      report_docs(Document.where(id: ids).active, r, false) # сформировать таблицу действующих документов процесса
      report_contracts(@bproce.contracts.active, r, false) # сформировать список договоров
      report_roles(@bproce.business_roles, r, false) # сформировать таблицу ролей
      report_workplaces(@bproce, r, false) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, false) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, false) # сформировать таблицу ресурсов процесса

      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "#{@bproce.id}-process-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # список процессов
  def print_list
    report = ODFReport::Report.new('reports/bp-list.odt') do |r|
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      nn = 0 # порядковый номер строки
      r.add_table('TABLE_01', @bproces, header: true) do |t|
        t.add_column(:nn) { |_ca| nn += 1 } # порядковый номер строки таблицы
        t.add_column(:owner) { |bproce| bproce.user&.displayname } # владелец процесса, если задан
        t.add_column(:name)
        t.add_column(:fullname)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "process_list-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # распоряжение о назачении на роли в процессе
  def print_order
    @business_roles = @bproce.business_roles.order(:name)
    report = ODFReport::Report.new('reports/bp-order.odt') do |r|
      form_report_header(r)
      r.add_field 'ORDERNUM', Date.current.strftime('%Y%m%d-п') + @bproce.id.to_s
      rr = 0 # порядковый номер строки для ролей
      r.add_section('ROLES', @business_roles) do |s|
        s.add_field(:rr) { |_nn| rr += 1 } # порядковый номер строки таблицы
        s.add_field(:nr, :name)
        s.add_field(:rdescription, :description)
        s.add_table('TABLE_USERS', :users, header: false, skip_if_empty: true) do |u|
          u.add_column(:displayname)
          u.add_column(:position)
        end
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: "#{@bproce.id}-order-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  def report_roles(roles, report, header)
    rr = 0 # порядковый номер строки для ролей
    report.add_table('TABLE_ROLES', roles, header: header, skip_if_empty: true) do |t|
      if roles.any? # если ролей нет - пустая таблица не будет выведена
        t.add_column(:rr) { |_nn| rr += 1 } # порядковый номер строки таблицы
        t.add_column(:nr, :name)
        t.add_column(:rdescription, :description)
      end
    end
  end

  def report_workplaces(bproce, report, header, _users = false)
    ww = 0 # порядковый номер строки для рабочих мест
    @workplaces = bproce.workplaces
    report.add_table('TABLE_PLACES', @workplaces, header: header, skip_if_empty: true) do |t|
      if @workplaces.any? # если рабочих мест нет - пустая таблица не будет выведена
        t.add_column(:ww) { |_nn| ww += 1 } # порядковый номер строки таблицы
        t.add_column(:nw, :name)
        t.add_column(:designation)
        t.add_column(:loca, :location)
        t.add_column(:wdescription, :description)
      end
    end
  end

  def report_docs(documents, report, header)
    nn = 0 # порядковый номер строки для документов
    report.add_table('TABLE_DOCS', documents, header: header, skip_if_empty: true) do |t|
      if documents.any? # если документов нет - пустая таблица не будет выведена
        t.add_column(:nn) { |_ca| nn += 1 } # порядковый номер строки таблицы
        t.add_column(:nd) { |document| ndoc = document.name }
        t.add_column(:idd, &:id)
        t.add_column(:status_doc, &:status)
        t.add_column(:approved) { |document| document.approved&.strftime('%d.%m.%Y') }
        t.add_column(:owner_doc) { |document| document.owner&.displayname }
      end
    end
  end

  # сформировать таблицу приложений процесса
  def report_bapps(bproce, report, header)
    pp = 0 # порядковый номер строки для приложений
    @bapps = bproce.bproce_bapps
    report.add_table('TABLE_BAPPS', @bapps, header: header, skip_if_empty: true) do |t|
      if @bapps.any? # если приложений нет - пустая таблица не будет выведена
        t.add_column(:pp) { |_nn| pp += 1 } # порядковый номер строки таблицы
        t.add_column(:na) { |ba| ba.bapp&.name } # наименование прилоджения
        t.add_column(:adescription) { |ba| ba.bapp&.description }
        t.add_column(:apurpose)
      end
    end
  end

  def report_contracts(contracts, report, header)
    cc = 0 # порядковый номер строки для документов
    contracts_label = ''
    report.add_table('TABLE_CONTRACTS', contracts, header: header, skip_if_empty: true) do |t|
      # [CONTRACT_NAME] [CONTRACT_DATE] [AGENT_NAME]
      if contracts.any? # если договоров нет - пустая таблица не будет выведена
        contracts_label = 'Юридическое обеспечение:'
        t.add_column(:cc) { |_ca| cc += 1 } # порядковый номер строки таблицы
        t.add_column(:contract_name) { |contract| "#{contract.contract_type} #{contract.name}" }
        t.add_column(:contract_date) do |contract|
          c_date = " #{contract.status}" if contract.status
          c_date = c_date + ' от ' + contract.date_begin.strftime('%d.%m.%Y') if contract.date_begin
        end
        t.add_column(:agent_name) { |contract| "с #{contract.agent&.name}" }
      end
    end
    report.add_field :contracts, contracts_label
  end

  # сформировать таблицу ресурсов процесса
  def report_iresources(bproce, report, header)
    ir = 0 # порядковый номер строки для информационных ресурсов
    @iresources = bproce.bproce_iresource
    report.add_table('IRESOURCES', @iresources, header: header, skip_if_empty: true) do |t|
      if @iresources.any? # если инф.ресурсов нет - пустая таблица не будет выведена
        t.add_column(:ir) { |_nn| ir += 1 } # порядковый номер строки таблицы
        t.add_column(:label) { |ir| ir.iresource.label }
        t.add_column(:location) { |ir| ir.iresource.location }
        t.add_column(:alocation) { |ir| ir.iresource.alocation }
        t.add_column(:note) { |ir| ir.iresource.note }
        t.add_column(:rpurpose)
      end
    end
  end

  def report_metrics(metrics, report, header)
    report.add_table('TABLE_METRICS', metrics, header: header, skip_if_empty: true) do |t|
      if metrics.any? # если метрик нет - пустая таблица не будет выведена
        report.add_field :metrics, 'Метрики процесса:'
        t.add_column(:men, &:name)
        t.add_column(:med) { |metric| metric.description.to_s }
        t.add_column(:idm) { |metric| metric.id.to_s }
      else
        report.add_field :metrics, ''
      end
    end
  end

  def form_report_header(report)
    report.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
    report.add_field :id, @bproce.id
    report.add_field :shortname, @bproce.shortname
    report.add_field :name, @bproce.name
    report.add_field :fullname, @bproce.fullname
    report.add_field :goal, @bproce.goal
    report.add_field :description, @bproce.description
    if @bproce.parent_id
      report.add_field :parent, @bproce.parent.name
      report.add_field :parent_id, ' #' + @bproce.parent_id.to_s
    else
      report.add_field :parent, '-'
      report.add_field :parent_id, ' '
    end
    if @bproce.user_id # владелец процесса
      report.add_field :owner, @bproce.user.displayname
    else
      report.add_field :owner, '-'
    end
  end
end
