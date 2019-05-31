# frozen_string_literal: true

class LetterAppendixesController < ApplicationController
  respond_to :html
  before_action :authenticate_user!, only: :edit
  before_action :set_letter_appendix, only: %i[edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def edit
    @letter = @letter_appendix.letter if @letter_appendix
  end

  def update
    @letter = @letter_appendix.letter if @letter_appendix
    if @letter_appendix.update(letter_appendix_params)
    else
      render action: 'edit'
    end
  end

  def destroy
    @letter = @letter_appendix.letter if @letter_appendix
    if @letter_appendix.destroy
    end
    redirect_to letter_url(@letter), notice: 'Letter_appendix was successfully destroyed.'
  end

  private

  def set_letter_appendix
    if params[:id].present?
      @letter_appendix = LetterAppendix.find(params[:id])
    else
      @letter = Letter.new
    end
  end

  def letter_appendix_params
    params.require(:letter_appendix).permit(:letter_id, :name, :appendix)
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, Скан договора не найден.'
    redirect_to action: :index
  end
end
