class BusinessRolesController < ApplicationController
  require 'net/smtp'
  respond_to :html
  respond_to :odt, :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]
  before_filter :get_business_role, :except => [:index, :print, :new]

  def index
    if params[:all].present?
      @business_roles = BusinessRole.order(sort_column + ' ' + sort_direction)
    else
      @business_roles = BusinessRole.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page])
      #@business_roles = BusinessRole.page(params[:page]).search(params[:search])
      #@business_roles = BusinessRole.paginate(:per_page => 10, :page => params[:page])
    end
    #@business_roles = @business_roles.find(:all, :include => :users)
    @business_roles = @business_roles.includes(:users)
    respond_to do |format|
      format.html
      format.odt { print }
    end
  end
  
  def new
    @business_role = BusinessRole.new
    if params[:bproce_id].present?
      @bproce = Bproce.find(params[:bproce_id])
      @business_role.bproce_id = @bproce.id
    end
    respond_with(@business_role)
  end

  def create
    @business_role = BusinessRole.new(params[:business_role])
    if params[:business_role][:bproce_name].present?
      name = params[:business_role][:bproce_name]
      @bproce = Bproce.where(:name => name).first
      @business_role.bproce_id = @bproce.id
    end

    flash[:notice] = "Successfully created role." if @business_role.save
    respond_with(@business_role)
  end

  def show
    respond_with(@business_role)
  end

  def edit
    @user_business_role = UserBusinessRole.new(:business_role_id => @business_role.id, date_from:  Date.today.strftime("%d.%m.%Y"), date_to: Date.today.change(:month => 12, :day => 31).strftime("%d.%m.%Y"))
    respond_with(@business_role, @user_business_role)
  end

  def update
    @user_business_role = UserBusinessRole.new(:business_role_id => @business_role.id)
    flash[:notice] = "Successfully updated role." if @business_role.update_attributes(params[:business_role])
    begin
      BusinessRoleMailer.update_business_role(@business_role, current_user).deliver    # оповестим исполнителей роли об изменениях
    rescue  Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to business role workers"
    end
    respond_with(@business_role)
  end

  def destroy
    flash[:notice] = "Successfully destroyed business_role." if @business_role.destroy
    respond_with(@business_role)
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_business_role
    if params[:search].present? # это поиск
      @broles = BusinessRole.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page]).find(:all, :include => :users)
      render :index # покажем список найденных бизнес-ролей
    else
      @business_role = params[:id].present? ? BusinessRole.find(params[:id]) : BusinessRole.new
    end
  end

  def print
    report = ODFReport::Report.new("reports/broles.odt") do |r|
      nn = 0
      r.add_field "REPORT_DATE", Date.today
      r.add_table("TABLE_01", @business_roles, :header=>true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name)
        t.add_column(:bpname) do |br|
          "#{br.bproce.shortname}" if :bproce_id?
        end
        t.add_column(:description)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "business_roles.odt",
      :disposition => 'inline' )
  end

end
