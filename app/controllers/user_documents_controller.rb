class UserDocumentsController < ApplicationController
  respond_to :html, :xml, :json

  def destroy
    if current_user
      @document = Document.find(params[:id]) if params[:id].present?
      @user_document = UserDocument.where(user_id: current_user.id, document_id: @document.id).first
      @user_document.destroy if @user_document
      respond_with @document, notice: '#' + @document.id.to_s + ' удален из Избранного.'
    end
  end
end
