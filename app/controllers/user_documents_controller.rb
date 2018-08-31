# frozen_string_literal: true

class UserDocumentsController < ApplicationController
  respond_to :html, :xml, :json

  def destroy
    return unless current_user
    @document = Document.find(params[:id]) if params[:id].present?
    @user_document = UserDocument.where(user_id: current_user.id, document_id: @document.id).first
    @user_document&.destroy
    respond_with @document, notice: "##{@document.id} удален из Избранного."
  end
end
