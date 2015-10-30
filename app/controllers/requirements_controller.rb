class RequirementsController < ApplicationController
  respond_to :html, :json
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  def index
    @requirements = Requirement.search(params[:search]).includes(:user).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    @title_requirements = "Требования"
  end

  def show
    @tasks = Task.where('requirement_id = ?', @requirement.id).order('duedate, status')
  end

  def new
    @requirement = Requirement.new
    @requirement.letter_id = params[:letter_id] if params[:letter_id].present?
    @requirement.author_id = current_user.id if user_signed_in?
  end

  def edit
     @user_requirement = UserRequirement.new(requirement_id: @requirement.id)
  end

  def create
    @requirement = Requirement.new(requirement_params)

    if @requirement.save
      redirect_to @requirement, notice: 'Requirement was successfully created.'
    else
      render action: 'new'
    end
  end

  def create_task
    parent_requirement = Requirement.find(params[:id]) 
    redirect_to proc { new_task_url(requirement_id: parent_requirement.id) } and return
  end

  def create_user
    @requirement = Requirement.find(params[:id])
    @user_requirement = UserRequirement.new(requirement_id: @requirement.id)    # заготовка для исполнителя
    render :create_user
  end

  def update
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: 'Requirement was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def update_user
    user_requirement = UserRequirement.new(params[:user_requirement]) if params[:user_requirement].present?
    if user_requirement
      user_requirement_clone = UserRequirement.where(requirement_id: user_requirement.requirement_id, user_id: user_requirement.user_id).first  # проверим - нет такого исполнителя?
      if user_requirement_clone
        user_requirement_clone.status = user_requirement.status
        user_requirement = user_requirement_clone
      end
      if user_requirement.save
        flash[:notice] = "Исполнитель #{user_requirement.user_name} назначен"
        begin
          UserRequirementMailer.user_requirement_create(user_requirement, current_user).deliver_now    # оповестим нового исполнителя
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          flash[:alert] = "Error sending mail to #{user_requirement.user.email}"
        end
        @requirement = user_requirement.requirement   #requirement.find(@user_requirement.requirement_id)
        @requirement.update_column(:status, 5) if @requirement.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = "Ошибка - ФИО Исполнителя не указано."
    end
    respond_with(@requirement)
  end

  def destroy
    @requirement.destroy
    redirect_to requirements_url, notice: 'Requirement was successfully destroyed.'
  end

  private
    def set_requirement
      @requirement = Requirement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def requirement_params
      params.require(:requirement).permit(:label, :date, :duedate, :source, :body, :status, :status_name, :result, :letter_id, :author_id, :author_name)
    end
    def sort_column
      params[:sort] || "duedate"
    end

    def sort_direction
      params[:direction] || "desc"
    end

end
