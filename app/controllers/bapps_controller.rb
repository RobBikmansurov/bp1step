class BappsController < ApplicationController
  respond_to :html
  respond_to :pdf, :odf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bapp, :except => [:index, :print]

  def index
    if params[:bproce_id].present?  # это приложения выбранного процесса
      @bp = Bproce.find(params[:bproce_id]) # информация о процессе
      @bproce_bapps = @bp.bproce_bapps.paginate(:per_page => 10, :page => params[:page])
    else
      if params[:all].present?
        @bapps = Bapp.all
      else
        if params[:apptype].present?
          @bapps = Bapp.searchtype(params[:apptype]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        else
          @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        end
      end
    end
    respond_to do |format|
      format.html
      format.pdf { print }
    end
  end
  
  def new
    respond_with(@bapp)
  end

  def create
    @bapp = Bapp.create(params[:bapp])
    flash[:notice] = "Successfully created bapp." if @bapp.save
    respond_with(@bapp)
  end

  def show
    respond_with(@bapp = Bapp.find(params[:id]))
  end

  def edit
    @bproce_bapp = BproceBapp.new(:bapp_id => @bapp.id)
  end

  def update
    flash[:notice] = "Successfully updated bapp."  if @bapp.update_attributes(params[:bapp])
    respond_with(@bapp)
  end

  def destroy
    flash[:notice] = "Successfully destroyed bapp." if @bapp.destroy
    respond_with(@bapp)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_bapp
    if params[:search].present? # это поиск
      @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @bapp = params[:id].present? ? Bapp.find(params[:id]) : Bapp.new
    end
  end

  def print
    report = ODFReport::Report.new("reports/bapps.odt") do |r|
      nn = 0
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_table("TABLE_01", @bapps, :header=>true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name, :name)
        t.add_column(:description, :description)
        t.add_column(:purpose, :purpose)
        t.add_column(:apptype, :apptype)
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
