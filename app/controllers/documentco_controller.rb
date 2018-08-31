# frozen_string_literal: true

class DocumentcoController < ApplicationController
  respond_to :html, :xml, :json
  def index
    @documents = Document.search(params[:search]).paginate(per_page: 10, page: params[:page])
    @document = @documents.first
  end

  def show
    @documents = Document.search(params[:search]).paginate(per_page: 10, page: params[:page])
    logger.debug(@documents.to_yaml)
    logger.debug(params[:id], @id)
    if @documents.any? { |d| d.id == params[:id] }
      logger.debug(params[:id])
      @document = Document.find(params[:id])
    else
      logger.debug('1')
      @document = @documents.first
    end
  end
end
