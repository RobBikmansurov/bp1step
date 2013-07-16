# coding: utf-8
class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_user, :except => [:index, :autocomplete]

  def index
    if params[:role].present?
      @role = Role.find_by_name(params[:role])
      @users = @role.users.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      if params[:office].present?
        @users = User.where(:office => params[:office]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        if params[:all].present?
          @users = User.order(sort_column + ' ' + sort_direction)
        else
          @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        end
      end
    end
  end

  def autocomplete
    @users = User.order(:displayname).where("displayname like ?", "%#{params[:term]}%")
    render json: @users.map(&:displayname)
  end

  def show
    @uroles = @usr.user_business_role   # исполняет роли
    @uworkplaces = @usr.user_workplace 	# рабочие места пользователя
    @documents = Document.order(:name).find_all_by_owner_id(@usr)
    respond_with()
  end

  def edit
  end

  def update
    if @usr.update_attributes(params[:user])
      redirect_to @usr, notice: "Successfully created user access roles."
    else
      render :edit
    end
    #@usr = User.find(params[:id])
    #if params[:role].present?
      #@business_role = Role.new(params[:business_role])
      #@user_role.save if !@user_role.nil?
    #end
    #redirect_to :action => :edit
  end

  def order   # распоряжение о назначении исполнителей на роли в процессе
    print_order
  end

private

  # распоряжение о назачении на роли в процессе
  def print_order
    @business_roles = @usr.business_roles.includes(:bproce).order(:name)
    report = ODFReport::Report.new("reports/user-order.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field "ORDERNUM", Date.today.strftime('%Y%m%d-с') + @usr.id.to_s
      r.add_field :displayname, @usr.displayname
      r.add_field :position, @usr.position
      rr = 0
      r.add_table("ROLES", @business_roles, :header => false, :skip_if_empty => true) do |t|
        t.add_column(:rr) do |n1| # порядковый номер строки таблицы
          rr += 1
        end
        t.add_column(:nr, :name)
        t.add_column(:rdescription, :description)
        t.add_column(:process_name) do |bp|
          bp.bproce.name
        end
        t.add_column(:process_id) do |bp|
          bp.bproce.id
        end
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "order.odt",
      :disposition => 'inline' )
  end

  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_user
    if params[:search].present? # это поиск
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @usr = params[:id].present? ? User.find(params[:id]) : User.new
    end
  end

end
