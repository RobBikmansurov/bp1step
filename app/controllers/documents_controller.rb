class DocumentsController < ApplicationController
  respond_to :html, :xml, :json

  def index
##    @documents = Document.all
    @documents = Document.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
##      format.json { render json: @documents }
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully saved.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @document = Document.new(params[:document])
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

end
