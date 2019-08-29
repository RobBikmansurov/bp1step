# frozen_string_literal: true

class UserLettersController < ApplicationController
  respond_to :html, :xml, :json
  before_action :authenticate_user!, only: %i[new create destroy]

  def show
    @user_letter = UserLetter.find(params[:id])
    redirect_to(letter_path(@user_letter.letter_id)) && return
  end

  def new
    @user_letter = UserLetter.new(status: 0)
  end

  def create
    @user_letter = UserLetter.new(user_letter_params)
    if @user_letter.save
      flash[:notice] = 'Successfully created user_letter.'
      begin
        UserLetterMailer.user_letter_create(@user_letter, current_user).deliver_now # оповестим нового исполнителя
      rescue StandardError => e
        flash[:alert] = "Error sending mail to #{@user_letter.user.email}\n#{e}"
      end
      letter = Letter.find(@user_letter.letter_id)
      letter.update! status: 5 if letter.status < 1 # если есть ответственные - статус = Назначено
    else
      flash[:alert] = 'Error create user_letter'
    end
    respond_with(@user_letter)
  end

  def destroy
    @user_letter = UserLetter.find(params[:id])   # нашли удаляемую связь
    @letter = Letter.find(@user_letter.letter_id) # запомнили письмо для этой удаляемой связи
    begin
      UserLetterMailer.user_letter_destroy(@user_letter, current_user).deliver_now # оповестим исполнителя
    rescue StandardError => e
      flash[:alert] = "Error sending mail to #{@user_letter.user.email}\n#{e}"
    end
    if @user_letter.destroy # удалили связь
      @letter.update! status: 0 unless @letter.user_letter.first # если нет ответственных - статус = Новое
    end
    respond_with(@letter) # вернулись в письмо
  end

  private

  def user_letter_params
    params.require(:user_letter)
          .permit(:user_id, :letter_id, :status, :user_name)
  end
end
