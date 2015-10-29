class RequirementsController < ApplicationController
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  def index
    @requirements = Requirement.search(params[:search]).includes(:user).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    @title_requirements = "Требования"
  end

  def show
    @tasks = Task.where('requirement_id = ?', @requirement.id)
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

  def update
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: 'Requirement was successfully updated.'
    else
      render action: 'edit'
    end
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
