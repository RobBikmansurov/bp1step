class BappsController < ApplicationController
  # GET /bapps
  # GET /bapps.json
  def index
    @bapps = Bapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bapps }
    end
  end

  # GET /bapps/1
  # GET /bapps/1.json
  def show
    @bapp = Bapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bapp }
    end
  end

  # GET /bapps/new
  # GET /bapps/new.json
  def new
    @bapp = Bapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bapp }
    end
  end

  # GET /bapps/1/edit
  def edit
    @bapp = Bapp.find(params[:id])
  end

  # POST /bapps
  # POST /bapps.json
  def create
    @bapp = Bapp.new(params[:bapp])

    respond_to do |format|
      if @bapp.save
        format.html { redirect_to @bapp, notice: 'Bapp was successfully created.' }
        format.json { render json: @bapp, status: :created, location: @bapp }
      else
        format.html { render action: "new" }
        format.json { render json: @bapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bapps/1
  # PUT /bapps/1.json
  def update
    @bapp = Bapp.find(params[:id])

    respond_to do |format|
      if @bapp.update_attributes(params[:bapp])
        format.html { redirect_to @bapp, notice: 'Bapp was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bapps/1
  # DELETE /bapps/1.json
  def destroy
    @bapp = Bapp.find(params[:id])
    @bapp.destroy

    respond_to do |format|
      format.html { redirect_to bapps_url }
      format.json { head :ok }
    end
  end
end
