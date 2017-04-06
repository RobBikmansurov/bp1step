class AgentsController < ApplicationController
  before_action :authenticate_user! # , :only => [:edit, :new, :create, :show]
  before_action :set_agent, only: %i[show edit update destroy new_contract new]
  autocomplete :bproce, :name, extra_data: [:id]

  def index
    @agents = Agent.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
  end

  def show
    @contracts = Contract.where(agent_id: @agent.id).order(:lft)
  end

  def new
  end

  def new_contract # новый договор контрагента
    redirect_to new_contract_path({agent_id: @agent.id})
  end

  def edit
  end

  def create
    @agent = Agent.new(agent_params)

    if @agent.save
      redirect_to @agent, notice: 'Agent was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @agent.update(agent_params)
      redirect_to @agent, notice: 'Agent was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @agent.destroy
    redirect_to agents_url, notice: 'Agent was successfully destroyed.'
  end

  def autocomplete
    @agents = Agent.order(:name).where('name ilike ?', "%#{params[:term]}%")
    render json: @agents.map(&:name)
  end

  private

  def set_agent
    if params[:search].present? # это поиск
      @agents = Agent.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      if params[:id].present?
        @agent = Agent.find(params[:id])
      else
        @agent = Agent.new
      end
    end
  end

  def agent_params
    params.require(:agent).permit(:shortname, :name, :town, :address, :contacts, :note)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end
end
