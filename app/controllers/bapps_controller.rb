class BappsController < ApplicationController
  respond_to :html
  respond_to :pdf, :odf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_bapp, :except => :index

  def index
    if params[:bproce_id].present?
      @bproce = Bproce.find(params[:bproce_id])
      @bapps = @bproce.bapps.paginate(:per_page => 10, :page => params[:page])
    else
      if params[:all].present?
        @bapps = Bapp.all
      else
        @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
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
    if flash[:bapp]
      @bapp = flash[:bapp]
    else
      @bapp = Bapp.find(params[:id])
      @bproce_bapp = BproceBapp.new(:bapp_id => @bapp.id)
    end
  end

  def update
    flash[:notice] = "Successfully updated bapp."  if @bapp.update_attributes(params[:bapp])
    if !@bapp.save # there was an error!
      flash[:bapp] = @bapp
      redirect_to :action => :edit
    end
    #redirect_to :action => :edit
    redirect_to :action => :index  # пойдем сразу на список Приложений
    #respond_with(@bapp)
  end

  def destroy
    @bapp.destroy
    flash[:notice] = "Successfully destroyed bapp." if @bapp.save
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
    @bapp = params[:id].present? ? Bapp.find(params[:id]) : Bapp.new
  end

  def print
    report = ODFReport::Report.new("reports/bapps.odt") do |r|
      r.add_field "REPORT_DATE", Date.today
      r.add_table("TABLE_01", @bapps, :header=>true) do |t|
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
