class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy]

  # GET /agents
  def index
    @agents = Agent.all
  end

  # GET /agents/1
  def show
  end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents
  def create
    @agent = Agent.new(agent_params)

    if @agent.save
      redirect_to @agent, notice: 'Agent was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /agents/1
  def update
    if @agent.update(agent_params)
      redirect_to @agent, notice: 'Agent was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /agents/1
  def destroy
    @agent.destroy
    redirect_to agents_url, notice: 'Agent was successfully destroyed.'
  end

  def autocomplete
    @agents = Agent.order(:name).where("name ilike ?", "%#{params[:term]}%")
    render json: @agents.map(&:name)
  end

  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def agent_params
      params.require(:agent).permit(:name, :town, :address, :contacts)
    end
end
