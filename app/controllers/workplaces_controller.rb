# frozen_string_literal: true

class WorkplacesController < ApplicationController
  include Reports
  respond_to :html
  respond_to :pdf, :odt, :xml, :json, only: %i[index switch]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit update new create]
  before_action :set_workplace, except: %i[index switch]
  # load_and_authorize_resource
  autocomplete :bproce, :name, extra_data: [:id]

  def index
    if params[:all].present?
      @workplaces = Workplace.includes(:users)
    else
      @workplaces = if params[:location].present?
                      Workplace.where(location: params[:location])
                    else
                      @workplaces = if params[:switch].present?
                                      Workplace.where(switch: params[:switch])
                                    else
                                      Workplace.search(params[:search])
                                    end
                    end
      @workplaces = @workplaces.includes(:users)
                               .order(sort_order(sort_column, sort_direction))
                               .paginate(per_page: 10, page: params[:page])
    end
    respond_to do |format|
      format.html
      format.odt { print }
      format.json { render json: @workplaces, except: %i[description name created_at updated_at] }
    end
  end

  def switch
    @workplaces = Workplace.where(typical: false).includes(:users).order(:switch, :port)
    print_switch
  end

  def show
    respond_with(@workplace)
  end

  def new
    @bproce_workplace = BproceWorkplace.new
    @workplace.location = params[:location] if params[:location].present?
    respond_with(@workplace)
  end

  def create
    @workplace = Workplace.new(workplace_params)
    if @workplace.save
      redirect_to @workplace, notice: 'Workplace was successfully created.'
    else
      render action: 'new'
    end
  end

  def create_user
    @workplace = Workplace.find(params[:id])
    @user_workplace = UserWorkplace.new(workplace_id: @workplace.id) # заготовка для исполнителя
    render :create_user
  end

  def update_user
    user_workplace = UserWorkplace.new(user_workplace_params) if params[:user_workplace].present?
    if user_workplace
      if user_workplace.save
        flash[:notice] = "#{user_workplace.user_name} на новом рабочем месте - [#{@workplace.name}]"
        begin
          UserWorkplaceMailer.user_workplace_create(user_workplace, current_user).deliver_now # оповестим нового сотрудника
        rescue StandardError => e
          flash[:alert] = "Error sending mail to #{user_workplace.user.email}\n#{e}"
        end
        @workplace = user_workplace.workplace
      end
    else
      flash[:alert] = 'Ошибка - ФИО Сотрудника не указано.'
    end
    respond_with(@workplace)
  end

  def edit
    @bproce_workplace = BproceWorkplace.new(workplace_id: @workplace.id)
    @user_workplace = UserWorkplace.new(workplace_id: @workplace.id)
    respond_with(@workplace)
  end

  def update
    @bproce_workplace = BproceWorkplace.new(workplace_id: @workplace.id)
    @user_workplace = UserWorkplace.new(workplace_id: @workplace.id)
    flash[:notice] = 'Successfully updated workplace.' if @workplace.update(workplace_params)
    respond_with(@workplace)
  end

  def destroy
    flash[:notice] = 'Successfully destroyed workplace.' if @workplace.destroy
    respond_with(@workplace)
  end

  def autocomplete
    @workplaces = Workplace.order(:designation)
                           .where('designation ilike ? or name ilike ?', "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @workplaces.map(&:designation)
  end

  private

  def workplace_params
    params.require(:workplace)
          .permit(:name, :designation, :description, :typical, :location, :switch, :port)
  end

  def user_workplace_params
    params.require(:user_workplace)
          .permit(:workplace_id, :user_id, :date_from, :date_to, :note, :user_name)
  end

  def sort_column
    params[:sort] || 'designation'
  end

  def set_workplace
    if params[:search].present? # это поиск
      @workplaces = Workplace.search(params[:search])
                             .order(sort_order(sort_column, sort_direction))
                             .paginate(per_page: 10, page: params[:page]).find(:all, include: :users)
      render :index # покажем список найденного
    else
      @workplace = params[:id].present? ? Workplace.find(params[:id]) : Workplace.new
    end
  end

  def record_not_found
    flash[:alert] = 'Требуемое рабочее место не найдено, #id= ' + params[:id]
    redirect_to action: :index
  end

  def print
    report = ODFReport::Report.new('reports/workplaces.odt') do |r|
      nn = 0
      r.add_table('TABLE_01', @workplaces, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:designation, :designation)
        t.add_column(:name, :name)
        t.add_column(:description, :description)
        t.add_column(:location, :location)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'workplaces.odt',
                               disposition: 'inline'
  end

  # подключения рабочих мест
  def print_switch
    report = ODFReport::Report.new('reports/wp_switch.odt') do |r|
      nn = 0
      r.add_table('TABLE_01', @workplaces, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:designation)
        t.add_column(:name)
        t.add_column(:switch)
        t.add_column(:port)
        t.add_column(:location)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'switch.odt',
                               disposition: 'inline'
  end
end
