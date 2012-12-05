class BprocesController < ApplicationController
  respond_to :html
  respond_to :pdf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => :index

  def list
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction)
  end
  
  def index
    if params[:all].present?
      @bproces = Bproce.order(sort_column + ' ' + sort_direction)
    else
      @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
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
    respond_to do |format|
      format.html { print_card }
      format.pdf { print_card }
    end
  end

  def new
    respond_with(@bproce)
  end

  def edit
    @business_role = BusinessRole.new(:bproce_id => @bproce.id)
    @document = Document.new(:bproce_id => @bproce.id)  # заготовка для нового документа
    @subproce = Bproce.new(:parent_id => @bproce.id)  # заготовка для подпроцесса
    @bproce_bapp = BproceBapp.new(:bproce_id => @bproce.id)  # заготовка для нового приложения
    #@user = User.find_or_initialize(@bproce.user_id)
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
    if !@bproce.save # there was an error!
      flash[:bproce] = @bproce
      redirect_to :action => :edit
    end
    #redirect_to :action => :index  # пойдем сразу на список Процессов
    redirect_to :action => :show  # пойдем сразу на список Процессов
  end

  def destroy
    @bproce.destroy
    flash[:notice] = "Successfully destroyed Bproce." if @bproce.save
    respond_with(@bproce)
  end

private
  def sort_column
    params[:sort] || "lft"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_bproce
    @bproce = params[:id].present? ? Bproce.find(params[:id]) : Bproce.new
  end

  def print
    report = ODFReport::Report.new("reports/bprocess.odt") do |r|
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
      r.add_field "REPORT_DATE", Date.today
      r.add_field :id, @bproce.id
      r.add_field :shortname, @bproce.shortname
      r.add_field :name, @bproce.name
      r.add_field :fullname, @bproce.fullname
      r.add_field :goal, @bproce.goal
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

      nn = 0 # порядковый номер строки для документов
      r.add_table("TABLE_DOCS", @bproce.documents, :header => true, :skip_if_empty => true) do |t|
        if @bproce.documents.count > 0  # если документов нет - пустая таблица не будет выведена
          t.add_column(:nn) do |ca| # порядковый номер строки таблицы
            nn += 1
          end
          t.add_column(:nd) do |document|
            ndoc = document.name
          end
          t.add_column(:approved)
          t.add_column(:responsible) do |document|  # владелец документа, если задан
            if document.responsible
              u=User.find(document.responsible)
              "#{u.displayname}"
            end
          end
        end
      end

      rr = 0 # порядковый номер строки для ролей
      @roles = @bproce.business_roles
      r.add_table("TABLE_ROLES", @roles, :header=>true, :skip_if_empty => true) do |t|
        if @roles.count > 0  # если ролей нет - пустая таблица не будет выведена
          t.add_column(:rr) do |nn| # порядковый номер строки таблицы
            rr += 1
          end
          t.add_column(:nr, :name)
          t.add_column(:description)
        end
      end

      ww = 0 # порядковый номер строки для рабочих мест
      @workplaces = @bproce.workplaces
      r.add_table("TABLE_PLACES", @workplaces, :header=>true, :skip_if_empty => true) do |t|
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

      pp = 0 # порядковый номер строки для приложений
      @bapps = @bproce.bapps
      r.add_table("TABLE_BAPPS", @bapps, :header=>true, :skip_if_empty => true) do |t|
        if @bapps.count > 0  # если приложений нет - пустая таблица не будет выведена
          t.add_column(:pp) do |nn| # порядковый номер строки таблицы
            pp += 1
          end
          t.add_column(:na, :name)
          t.add_column(:description)
          t.add_column(:purpose)
        end
      end

      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
      r.add_field "REPORT_DATE", Date.today
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "card.odt",
      :disposition => 'inline' )
  end

end
