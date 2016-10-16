# coding: utf-8
class BprocesController < ApplicationController
  include TheSortableTreeController::Rebuild

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  respond_to :html
  respond_to :pdf, :xml, :json, :only => [:index, :list]
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => [:index, :list, :manage, :autocomplete]
  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]

  def list  # плоский список процессов без дерева
    @bproces = Bproce.search('?', params[:search]).order(sort_column + ' ' + sort_direction).find(:all, :include => :user)
    respond_to do |format|
      format.html
      format.pdf { print_list }
    end
  end

  def index
    if params[:all].present?
      #@bproces = Bproce.order(sort_column + ' ' + sort_direction)
      @bproces = Bproce.nested_set.order(:lft)
    else
      if params[:tag].present?
        #@bproces = Bproce.tagged_with(params[:tag]).nested_set.search(params[:search]).select('bproces.id, shortname, name as title, parent_id').all
        @bproces = Bproce.nested_set.tagged_with(params[:tag]).search(params[:search]).order(:lft)
      else
        if params[:user].present? #  список процессов пользователя
          @user = User.find(params[:user])
          @bproces = Bproce.nested_set.where(:user_id => params[:user]).order(:lft)
        else
          #@bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
          @bproces = Bproce.nested_set.search(params[:search]).order(:lft)
        end
      end
    end
    respond_to do |format|
      format.html
      format.pdf { print }
    end
  end

  def autocomplete
    @bproces = Bproce.order(:name).where("id = ? or name ilike ? or shortname ilike ? ", "#{params[:term].to_i}", "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @bproces.map(&:name)
  end

  def show
    @metrics = Metric.where(:bproce_id => @bproce.id).order(:name) if @bproce # метрики процесса
    @directive_of_bproce = Directive.last.directives_of_bproce(@bproce.id) if @bproce
    #@contracts = Contract.where(:bproce_id => @bproce.id)  # договоры процесса
    respond_with(@bproce)
  end

  def card
    print_card # карточка процесса
  end

  def check_list
    print_check_list # чек-лист карточки процесса
  end

  def doc
    print_doc  # заготовка описания процесса
  end

  def order   # распоряжение о назначении исполнителей на роли в процессе
    print_order
  end

  def new
    #respond_with(@bproce)
  end

  def edit
    @business_role = BusinessRole.new(:bproce_id => @bproce.id)
    @document = Document.new(:bproce_id => @bproce.id)  # заготовка для нового документа
    @subproce = Bproce.new(:parent_id => @bproce.id)  # заготовка для подпроцесса
    @bproce_bapp = BproceBapp.new(:bproce_id => @bproce.id)  # заготовка для нового приложения
    @bproce_workplace = BproceWorkplace.new(:bproce_id => @bproce.id)  # заготовка для нового рабочего места
    @bproce_iresource = BproceIresource.new(:bproce_id => @bproce.id)  # заготовка для нового ресурса
  end

  def create
    @bproce = Bproce.new(params[:bproce])
    flash[:notice] = "Bproce was successfully created." if @bproce.save
    respond_with(@bproce)
  end

  def update
    if params[:business_role].present?
      @business_role = Role.new(params[:business_role])
      @business_role.save if !@business_role.nil?
    end
    if params[:document].present?
      @document = Document.new(params[:document])
      @document.save if !@document.nil?
    end
    flash[:notice] = "Successfully updated Bproce." if @bproce.update_attributes(params[:bproce])
    respond_with(@bproce)
  end

  def destroy
    flash[:notice] = "Successfully destroyed Bproce." if @bproce.destroy
    redirect_to :action => :index
  end

  def manage
    @bproces = Bproce.nested_set.select('id, shortname, name as title, parent_id').all
    #@bproces = Bproce.nested_set.roots.select('id, shortname, name as title, parent_id').all
  end

  def metrics
    @metrics = Metric.where(:bproce_id => @bproce.id).order(:name)  # метрики процесса
    respond_with(@bproce)
  end

  def new_metric
    @metric = Metric.new
    @metric.bproce_id = @bproce_id
    @metric.depth = 3
  end

private
  def sort_column
    params[:sort] || "lft"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_bproce
    if params[:search].present? # это поиск
      #@bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      @bproces = Bproce.search(params[:search])
      render :index # покажем список найденного
    else
      @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
    end
  end

  def record_not_found
    flash[:alert] = "Требуемый Процесс не найден."
    redirect_to action: :index
  end

  def print
    report = ODFReport::Report.new("reports/bprocess.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      nn = 0 # порядковый номер строки
      r.add_table("TABLE_01", @bproces, :header=>true) do |t|
        t.add_column(:nn) do |ca| # порядковый номер строки таблицы
          nn += 1
          "#{nn}."
        end
        t.add_column(:owner) do |bproce|  # владелец процесса, если задан
          if bproce.user_id
            bproce.user.displayname
          end
        end
        t.add_column(:name) do |bp|   # уровень вложенности процессов вместо наименования
          name = '..' * (bp.depth)
        end
        t.add_column(:fullname)
        t.add_column(:id)
        t.add_column(:goal)
      end
      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "processes-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  # печать Карточки процесса
  def print_card
    report = ODFReport::Report.new("reports/bp-card.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field :id, @bproce.id
      r.add_field :shortname, @bproce.shortname
      r.add_field :name, @bproce.name
      r.add_field :fullname, @bproce.fullname
      r.add_field :goal, @bproce.goal
      r.add_field :description, @bproce.description
      if @bproce.parent_id
        r.add_field :parent, @bproce.parent.name
        r.add_field :parent_id, " #" + @bproce.parent_id.to_s
      else
        r.add_field :parent, "-"
        r.add_field :parent_id, " "
      end
      if @bproce.user_id  # владелец процесса
        r.add_field :owner, @bproce.user.displayname
      else
        r.add_field :owner, "-"
      end

      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where("lft>? and rgt<?", @bproce.lft, @bproce.rgt).order("lft")  # все подпроцессы процесса
      r.add_table("SUBPROC", subs, :header => false, :skip_if_empty => true) do |t|
        if subs.count > 0  # если подпроцессов нет - пустая таблица не будет выведена
          t.add_column(:sp) do |ca| # порядковый номер строки таблицы
            sp += 1
          end
          t.add_column(:spname) do |sub|
            spname = '__' * (sub.depth - @bproce.depth) + sub.name
          end
          t.add_column(:sp_id) do |sub|
            sp_id = sub.id.to_s
          end
          t.add_column(:spowner) do |sp|
            spowner = sp.user.displayname if sp.user_id
          end
        end
      end
      @metrics = Metric.where(:bproce_id => @bproce.id).order(:name)  # метрики процесса
      report_metrics(@metrics, r, false) # сформировать список метрик процесса
      report_docs(@bproce.documents.active, r, false) # сформировать таблицу действующих документов процесса
      report_contracts(@bproce.contracts.active, r, false)   # сформировать список договоров
      report_roles(@bproce.business_roles, r, true) # сформировать таблицу ролей
      report_workplaces(@bproce, r, true) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, true) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, true) # сформировать таблицу ресурсов процесса

      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "#{@bproce.id}-card-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  # печатать чек-лист Карточки процесса
  def print_check_list
    report = ODFReport::Report.new("reports/bp-check.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field :id, @bproce.id
      r.add_field :shortname, @bproce.shortname
      r.add_field :name, @bproce.name
      r.add_field :fullname, @bproce.fullname
      r.add_field :goal, @bproce.goal
      r.add_field :description, @bproce.description
      if @bproce.parent_id
        r.add_field :parent, @bproce.parent.name
        r.add_field :parent_id, " #" + @bproce.parent_id.to_s
      else
        r.add_field :parent, "-"
        r.add_field :parent_id, " "
      end
      if @bproce.user_id  # владелец процесса
        r.add_field :owner, @bproce.user.displayname
      else
        r.add_field :owner, "-"
      end

      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where("lft>? and rgt<?", @bproce.lft, @bproce.rgt).order("lft")  # все подпроцессы процесса
      r.add_table("SUBPROC", subs, :header => false, :skip_if_empty => true) do |t|
        if subs.count > 0  # если подпроцессов нет - пустая таблица не будет выведена
          t.add_column(:sp) do |ca| # порядковый номер строки таблицы
            sp += 1
          end
          t.add_column(:spname) do |sub|
            spname = '__' * (sub.depth - @bproce.depth) + sub.name
          end
          t.add_column(:sp_id) do |sub|
            sp_id = sub.id.to_s
          end
          t.add_column(:spowner) do |sp|
            spowner = sp.user.displayname if sp.user_id
          end
        end
      end
      if @bproce.business_roles.count > 0
        roles = @bproce.business_roles.collect(&:name).join(', ')
      else
        roles = 'Роли не выделены!' # сформировать список ролей
      end
      r.add_field "ROLES", roles
      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      filename: "#{@bproce.id}-check_list-#{Date.current.strftime('%Y%m%d')}.odt",
      disposition: 'inline'
  end


  # заготовка описания процесса
  def print_doc
    report = ODFReport::Report.new("reports/bp-doc.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field :id, @bproce.id
      r.add_field :shortname, @bproce.shortname
      r.add_field :name, @bproce.name
      r.add_field :fullname, @bproce.fullname
      r.add_field :goal, @bproce.goal
      r.add_field :description, @bproce.description
      if @bproce.parent_id
        r.add_field :parent, @bproce.parent.name
        r.add_field :parent_id, " #" + @bproce.parent_id.to_s
      else
        r.add_field :parent, "-"
        r.add_field :parent_id, " "
      end
      if @bproce.user_id  # владелец процесса
        r.add_field :owner, @bproce.user.displayname
      else
        r.add_field :owner, "-"
      end
      sp = 0 # порядковый номер строки для подпроцессов
      subs = Bproce.where("lft>? and rgt<?", @bproce.lft, @bproce.rgt).order("lft")  # все подпроцессы процесса
      r.add_table("SUBPROC", subs, :header => false, :skip_if_empty => true) do |t|
        if subs.count > 0  # если документов нет - пустая таблица не будет выведена
          r.add_field :sub_process, 'В процесс входят следующие подпроцессы:'
          t.add_column(:sp) do |ca| # порядковый номер строки таблицы
            sp += 1
          end
          t.add_column(:spname) do |sub|
            spname = '__' * (sub.depth - @bproce.depth) + sub.name
          end
          t.add_column(:sp_id) do |sub|
            sp_id = sub.id.to_s
          end
        else
          r.add_field :sub_process, 'Подпроцессов нет.'
        end
      end

      @metrics = Metric.where(:bproce_id => @bproce.id).order(:name)  # метрики процесса
      report_metrics(@metrics, r, false) # сформировать список метрик процесса
      report_docs(@bproce.documents.active, r, false) # действующие документы процесса
      report_contracts(@bproce.contracts.active, r, false)   # сформировать список договоров
      report_roles(@bproce.business_roles, r, false) # сформировать таблицу ролей
      report_workplaces(@bproce, r, false) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, false) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, false) # сформировать таблицу ресурсов процесса


      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "#{@bproce.id}-process-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  def print_list
    report = ODFReport::Report.new("reports/bp-list.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      nn = 0 # порядковый номер строки
      r.add_table("TABLE_01", @bproces, :header=>true) do |t|
        t.add_column(:nn) do |ca| # порядковый номер строки таблицы
          nn += 1
          "#{nn}."
        end
        t.add_column(:owner) do |bproce|  # владелец процесса, если задан
          if bproce.user_id
            bproce.user.displayname
          end
        end
        t.add_column(:name)
        t.add_column(:fullname)
      end
      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "process_list-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  # распоряжение о назачении на роли в процессе
  def print_order
    @business_roles = @bproce.business_roles.order(:name)
    report = ODFReport::Report.new("reports/bp-order.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field "ORDERNUM", Date.today.strftime('%Y%m%d-п') + @bproce.id.to_s
      r.add_field :id, @bproce.id.to_s
      #r.add_field :shortname, @bproce.shortname
      #r.add_field :name, @bproce.name
      r.add_field :fullname, @bproce.fullname
      if @bproce.parent_id
        r.add_field :parent, @bproce.parent.name
        r.add_field :parent_id, @bproce.parent_id.to_s
      else
        r.add_field :parent, '-'
        r.add_field :parent_id, '-'
      end
      if @bproce.user_id  # владелец процесса
        r.add_field :owner, @bproce.user.displayname
      else
        r.add_field :owner, '-'
      end
      rr = 0 # порядковый номер строки для ролей
      nn = 0
      r.add_section("ROLES", @business_roles) do |s|
        s.add_field(:rr) do |nn| # порядковый номер строки таблицы
          rr += 1
        end
        s.add_field(:nr, :name)
        s.add_field(:rdescription, :description)
        s.add_table("TABLE_USERS", :users, :header => false, :skip_if_empty => true) do |u|
          u.add_column(:displayname)
          u.add_column(:position)
        end
      end

      r.add_field "USER_POSITION", current_user.position.mb_chars.capitalize.to_s
      r.add_field "USER_NAME", current_user.displayname
    end
   send_data report.generate, type: 'application/msword',
      :filename => "#{@bproce.id}-order-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  def report_roles(roles, r, header)
    rr = 0 # порядковый номер строки для ролей
    r.add_table("TABLE_ROLES", roles, :header => header, :skip_if_empty => true) do |t|
      if roles.count > 0  # если ролей нет - пустая таблица не будет выведена
        t.add_column(:rr) do |nn| # порядковый номер строки таблицы
          rr += 1
        end
        t.add_column(:nr, :name)
        t.add_column(:rdescription, :description)
      end
    end
  end

  def report_workplaces(bproce, r, header, users = false)
    ww = 0 # порядковый номер строки для рабочих мест
    @workplaces = bproce.workplaces
    r.add_table("TABLE_PLACES", @workplaces, :header => header, :skip_if_empty => true) do |t|
      if @workplaces.count > 0  # если рабочих мест нет - пустая таблица не будет выведена
        t.add_column(:ww) do |nn| # порядковый номер строки таблицы
          ww += 1
        end
        t.add_column(:nw, :name)
        t.add_column(:designation)
        t.add_column(:loca, :location)
        t.add_column(:wdescription,:description)
      end
    end
  end

  def report_docs(documents, r, header)
    nn = 0 # порядковый номер строки для документов
    r.add_table("TABLE_DOCS", documents, :header => header, :skip_if_empty => true) do |t|
      if documents.count > 0  # если документов нет - пустая таблица не будет выведена
        t.add_column(:nn) do |ca| # порядковый номер строки таблицы
          nn += 1
        end
        t.add_column(:nd) do |document|
          ndoc = document.name
        end
        t.add_column(:idd) do |document|
          di = document.id.to_s
        end
        t.add_column(:status_doc) do |document|
          ds = document.status.to_s
        end
        t.add_column(:approved) do |document|
          da = document.approved.strftime('%d.%m.%Y') if document.approved
        end
        t.add_column(:owner_doc) do |document|
          owner_doc = document.owner.displayname if document.owner
        end
      end
    end
  end

  def report_bapps(bproce, r, header) # сформировать таблицу приложений процесса
    pp = 0 # порядковый номер строки для приложений
    @bapps = bproce.bproce_bapps
    r.add_table("TABLE_BAPPS", @bapps, :header => header, :skip_if_empty => true) do |t|
      if @bapps.count > 0  # если приложений нет - пустая таблица не будет выведена
        t.add_column(:pp) do |nn| # порядковый номер строки таблицы
          pp += 1
        end
        t.add_column(:na) do |ba| # наименование прилоджения
          na = ba.bapp.name if ba.bapp
        end
        t.add_column(:adescription) do |ba|
          ades = ba.bapp.description if ba.bapp
        end
        t.add_column(:apurpose)
      end
    end
  end

  def report_contracts(contracts, r, header)
    cc = 0 # порядковый номер строки для документов
    contracts_label = ''
    r.add_table("TABLE_CONTRACTS", contracts, :header => header, :skip_if_empty => true) do |t|
      # [CONTRACT_NAME] [CONTRACT_DATE] [AGENT_NAME]
      if contracts.count > 0  # если договоров нет - пустая таблица не будет выведена
        contracts_label = "Юридическое обеспечение:"
        t.add_column(:cc) do |ca| # порядковый номер строки таблицы
          cc += 1
        end
        t.add_column(:contract_name) do |contract|
          c_name = contract.contract_type.to_s + ' ' + contract.name
        end
        t.add_column(:contract_date) do |contract|
          c_date = " #{contract.status}" if contract.status
          c_date = c_date + ' от ' + contract.date_begin.strftime('%d.%m.%Y') if contract.date_begin
        end
        t.add_column(:agent_name) do |contract|
          a_name = "с #{contract.agent.name}" if contract.agent
        end
      end
    end
    r.add_field :contracts, contracts_label
  end

  def report_iresources(bproce, r, header) # сформировать таблицу ресурсов процесса
    ir = 0 # порядковый номер строки для информационных ресурсов
    @iresources = bproce.bproce_iresource
    r.add_table("IRESOURCES", @iresources, :header => header, :skip_if_empty => true) do |t|
      if @iresources.count > 0  # если инф.ресурсов нет - пустая таблица не будет выведена
        t.add_column(:ir) do |nn| # порядковый номер строки таблицы
          ir += 1
        end
        t.add_column(:label) do |ir|
          lab = ir.iresource.label
        end
        t.add_column(:location) do |ir|
          loc =  ir.iresource.location
        end
        t.add_column(:alocation) do |ir|
          loc =  ir.iresource.alocation
        end
        t.add_column(:note) do |ir|
          note = ir.iresource.note
        end
        t.add_column(:rpurpose)
      end
    end
  end

  def report_metrics(metrics, r, header)
    me = 0 # порядковый номер строки для метрики
    r.add_table("TABLE_METRICS", metrics, :header => header, :skip_if_empty => true) do |t|
      if metrics.count > 0  # если метрик нет - пустая таблица не будет выведена
        r.add_field :metrics, "Метрики процесса:"
        t.add_column(:me) do |nme| # порядковый номер строки таблицы
          me += 1
        end
        t.add_column(:men) do |metric|
          n1 = metric.name
        end
        t.add_column(:med) do |metric|
          n2 = metric.description.to_s
        end
        t.add_column(:idm) do |metric|
          n3 = metric.id.to_s
        end
      else
        r.add_field :metrics, ''
      end
    end
  end


end
