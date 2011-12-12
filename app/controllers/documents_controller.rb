class DocumentsController < ApplicationController
  def index
    @documents = Document.all

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



end
