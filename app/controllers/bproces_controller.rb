class BprocesController < ApplicationController
  respond_to :html
  respond_to :xml, :json, :only => :index
  helper_method :sort_column, :sort_direction

  def index
    @bproces = Bproce.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /bproces/1
  # GET /bproces/1.json
  def show
    @bproce = Bproce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bproce }
    end
  end

  # GET /bproces/new
  # GET /bproces/new.json
  def new
    @bproce = Bproce.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bproce }
    end
  end

  # GET /bproces/1/edit
  def edit
    @bproce = Bproce.find(params[:id])
  end

  # POST /bproces
  # POST /bproces.json
  def create
    @bproce = Bproce.new(params[:bproce])

    respond_to do |format|
      if @bproce.save
        format.html { redirect_to @bproce, notice: 'Bproce was successfully created.' }
        format.json { render json: @bproce, status: :created, location: @bproce }
      else
        format.html { render action: "new" }
        format.json { render json: @bproce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bproces/1
  # PUT /bproces/1.json
  def update
    @bproce = Bproce.find(params[:id])

    respond_to do |format|
      if @bproce.update_attributes(params[:bproce])
        format.html { redirect_to @bproce, notice: 'Bproce was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bproce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bproces/1
  # DELETE /bproces/1.json
  def destroy
    @bproce = Bproce.find(params[:id])
    @bproce.destroy

    respond_to do |format|
      format.html { redirect_to bproces_url }
      format.json { head :ok }
    end
  end

private
  def sort_column
    params[:sort] || "shortname"
  end

  def sort_direction
    params[:direction] || "asc"
  end


end
