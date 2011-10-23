class BProcsController < ApplicationController
  # GET /b_procs
  # GET /b_procs.json
  def index
    @b_procs = BProc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @b_procs }
    end
  end

  # GET /b_procs/1
  # GET /b_procs/1.json
  def show
    @b_proc = BProc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @b_proc }
    end
  end

  # GET /b_procs/new
  # GET /b_procs/new.json
  def new
    @b_proc = BProc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @b_proc }
    end
  end

  # GET /b_procs/1/edit
  def edit
    @b_proc = BProc.find(params[:id])
  end

  # POST /b_procs
  # POST /b_procs.json
  def create
    @b_proc = BProc.new(params[:b_proc])

    respond_to do |format|
      if @b_proc.save
        format.html { redirect_to @b_proc, notice: 'B proc was successfully created.' }
        format.json { render json: @b_proc, status: :created, location: @b_proc }
      else
        format.html { render action: "new" }
        format.json { render json: @b_proc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /b_procs/1
  # PUT /b_procs/1.json
  def update
    @b_proc = BProc.find(params[:id])

    respond_to do |format|
      if @b_proc.update_attributes(params[:b_proc])
        format.html { redirect_to @b_proc, notice: 'B proc was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @b_proc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /b_procs/1
  # DELETE /b_procs/1.json
  def destroy
    @b_proc = BProc.find(params[:id])
    @b_proc.destroy

    respond_to do |format|
      format.html { redirect_to b_procs_url }
      format.json { head :ok }
    end
  end
end
