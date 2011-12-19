class WorkplacesController < ApplicationController
  # GET /workplaces
  # GET /workplaces.json
  def index
    @workplaces = Workplace.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workplaces }
    end
  end

  # GET /workplaces/1
  # GET /workplaces/1.json
  def show
    @workplace = Workplace.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @workplace }
    end
  end

  # GET /workplaces/new
  # GET /workplaces/new.json
  def new
    @workplace = Workplace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workplace }
    end
  end

  # GET /workplaces/1/edit
  def edit
    @workplace = Workplace.find(params[:id])
  end

  # POST /workplaces
  # POST /workplaces.json
  def create
    @workplace = Workplace.new(params[:workplace])

    respond_to do |format|
      if @workplace.save
        format.html { redirect_to @workplace, notice: 'Workplace was successfully created.' }
        format.json { render json: @workplace, status: :created, location: @workplace }
      else
        format.html { render action: "new" }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workplaces/1
  # PUT /workplaces/1.json
  def update
    @workplace = Workplace.find(params[:id])

    respond_to do |format|
      if @workplace.update_attributes(params[:workplace])
        format.html { redirect_to @workplace, notice: 'Workplace was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workplaces/1
  # DELETE /workplaces/1.json
  def destroy
    @workplace = Workplace.find(params[:id])
    @workplace.destroy

    respond_to do |format|
      format.html { redirect_to workplaces_url }
      format.json { head :ok }
    end
  end
end
