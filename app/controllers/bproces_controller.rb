class BprocesController < ApplicationController
  respond_to :html
  respond_to :pdf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bproce, :except => :card

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
    @bproces = Bproce.order(sort_column + ' ' + sort_direction)
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
      r.add_field "REPORT_DATE", Date.today
      r.add_table("TABLE_01", @bproces, :header=>true) do |t|
        t.add_column(:name, :name)
        t.add_column(:fullname, :fullname)
        t.add_column(:goal, :goal)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "documents.odt",
      :disposition => 'inline' )
  end

  def print_card
    report = ODFReport::Report.new("reports/bp-card.odt") do |r|
      r.add_field "REPORT_DATE", Date.today
      @nn = 0
      r.add_table("TABLE_01", @bproces, :header=>true) do |t|
        # TODO: здесь надо вставить порядковый номер строки в таблице
        # t.add_column(:nn, :id)
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
      :filename => "documents.odt",
      :disposition => 'inline' )
  end

end
