class BprocesController < ApplicationController
  include TheSortableTreeController::Rebuild

  respond_to :html
  respond_to :pdf, :xml, :json, :only => [:index, :list]
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => [:index, :list]

  def list  # плоский список процессов без дерева
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).find(:all, :include => :user)
    respond_to do |format|
      format.html
      format.pdf { print_list }
    end
  end
  
  def index
    if params[:all].present?
      @bproces = Bproce.order(sort_column + ' ' + sort_direction)
    else
      if params[:tag].present?
        @bproces = Bproce.tagged_with(params[:tag]).search(params[:search]).select('bproces.id, shortname, name as title, parent_id')
      else
        #@bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        @bproces = Bproce.nested_set.search(params[:search]).select('id, shortname, name as title, parent_id').all
      end
    end
    respond_to do |format|
      format.html
      format.pdf { print }
    end
  end

  def show
    respond_with(@bproce)
  end

  def card
    print_card # карточка процесса
  end

  def doc
    print_doc  # заготовка описания процесса
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
      @bproces = Bproce.search(params[:search]).nested_set.select('id, shortname, name as title, parent_id').all
      render :index # покажем список найденного
    else
      @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
    end
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
        t.add_column(:name)
        t.add_column(:fullname)
        t.add_column(:goal)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "processess.odt",
      :disposition => 'inline' )
  end

  # печать карточки процесса
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
      else
        r.add_field :parent, "-"
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
          t.add_column(:sp) do |ca| # порядковый номер строки таблицы
            sp += 1
          end
          t.add_column(:spname) do |sub|
            spname = '__' * (sub.depth - @bproce.depth) + sub.name
            #spname = sub.name
          end
        end
      end
      report_docs(@bproce.documents, r, false) # сформировать таблицу документов процесса
      report_roles(@bproce, r, true) # сформировать таблицу ролей
      report_workplaces(@bproce, r, true) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, true) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, true) # сформировать таблицу ресурсов процесса

      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "card.odt",
      :disposition => 'inline' )
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
      else
        r.add_field :parent, "-"
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
          t.add_column(:sp) do |ca| # порядковый номер строки таблицы
            sp += 1
          end
          t.add_column(:spname) do |sub|
            spname = '__' * (sub.depth - @bproce.depth) + sub.name
            #spname = sub.name
          end
        end
      end
      
      report_docs(@bproce.documents, r, false) # сформировать таблицу документов процесса
      report_roles(@bproce, r, false) # сформировать таблицу ролей
      report_workplaces(@bproce, r, false) # сформировать таблицу рабочих мест
      report_bapps(@bproce, r, false) # сформировать таблицу приложений процесса
      report_iresources(@bproce, r, false) # сформировать таблицу ресурсов процесса


      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "process.odt",
      :disposition => 'inline' )
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
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "process_list.odt",
      :disposition => 'inline' )
  end


  def report_roles(bproce, r, header)
    rr = 0 # порядковый номер строки для ролей
    @roles = bproce.business_roles
    r.add_table("TABLE_ROLES", @roles, :header => header, :skip_if_empty => true) do |t|
      if @roles.count > 0  # если ролей нет - пустая таблица не будет выведена
        t.add_column(:rr) do |nn| # порядковый номер строки таблицы
          rr += 1
        end
        t.add_column(:nr, :name)
        t.add_column(:description)
      end
    end
  end

  def report_workplaces(bproce, r, header)
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
        t.add_column(:description)
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
        t.add_column(:owner_doc) do |document|
          owner_doc = document.owner.displayname if document.owner
        end
        t.add_column(:approved) do |document|
          da = document.approved.strftime('%d.%m.%Y') if document.approved
        end
        t.add_column(:idd) do |document|
          di = document.id.to_s
        end
      end
    end
  end

  def report_bapps(bproce, r, header) # сформировать таблицу приложений процесса
    pp = 0 # порядковый номер строки для приложений
    @bapps = bproce.bapps
    r.add_table("TABLE_BAPPS", @bapps, :header => header, :skip_if_empty => true) do |t|
      if @bapps.count > 0  # если приложений нет - пустая таблица не будет выведена
        t.add_column(:pp) do |nn| # порядковый номер строки таблицы
          pp += 1
        end
        t.add_column(:na, :name)
        t.add_column(:description)
        t.add_column(:purpose)
      end
    end
  end

  def report_iresources(bproce, r, header) # сформировать таблицу ресурсов процесса
    ir = 0 # порядковый номер строки для информационных ресурсов
    @iresources = bproce.iresource
    r.add_table("IRESOURCES", @iresources, :header => header, :skip_if_empty => true) do |t|
      if @iresources.count > 0  # если инф.ресурсов нет - пустая таблица не будет выведена
        t.add_column(:ir) do |nn| # порядковый номер строки таблицы
          ir += 1
        end
        t.add_column(:label)
        t.add_column(:location)
        t.add_column(:note)
      end
    end
  end


end
