class WorkplacesController < ApplicationController
  respond_to :html
  respond_to :pdf, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :get_workplace, :except => [:index, :print]
  #load_and_authorize_resource

  def index
    if params[:all].present?
      @workplaces = Workplace.includes(:users)
    else
      if params[:location].present?
        @workplaces = Workplace.includes(:users).where(:location => params[:location]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        @workplaces = Workplace.includes(:users).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      end
    end
    respond_to do |format|
      format.html
      format.pdf { print }
    end
  end

  def show
    respond_with(@workplace = Workplace.find(params[:id]))
  end

  def new
    @bproce_workplace = BproceWorkplace.new
    @workplace.location = params[:location] if params[:location].present?
    respond_with(@workplace)
  end

  def create
    @workplace = Workplace.create(params[:workplace])
    flash[:notice] = "Successfully created workplace." if @workplace.save
    respond_with(@workplace)
  end

  def edit
    @bproce_workplace = BproceWorkplace.new(:workplace_id => @workplace.id)
    @user_workplace = UserWorkplace.new(:workplace_id => @workplace.id)
    respond_with(@workplace)
  end

  def update
    flash[:notice] = "Successfully updated workplace."  if @workplace.update_attributes(params[:workplace])
    respond_with(@workplace)
  end

  def destroy
    @workplace.destroy
    flash[:notice] = "Successfully destroyed workplace."  if @workplace.save
    respond_with(@workplace)
  end

private
  def sort_column
    params[:sort] || "designation"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_workplace
    if params[:search].present? # это поиск
      @workplaces = Workplace.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page]).find(:all, :include => :users)
    #@workplaces = @workplaces.find(:all, :include => :users)
      render :index # покажем список найденного
    else
      @workplace = params[:id].present? ? Workplace.find(params[:id]) : Workplace.new
    end
  end

  def print
    report = ODFReport::Report.new("reports/workplaces.odt") do |r|
      nn = 0
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_table("TABLE_01", @workplaces, :header=>true) do |t|
      t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:designation, :designation)
        t.add_column(:name, :name)
        t.add_column(:description, :description)
        t.add_column(:location, :location)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "workplaces.odt",
      :disposition => 'inline' )
  end

end
