class UserLettersController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, :only => [:new, :create, :destroy]
  
  def show
    @user_letter = UserLetter.find(params[:id])
    redirect_to letter_path(@user_letter.letter_id) and return
  end

  def new
    @user_letter = UserLetter.new(status: 0)
  end

  def create
    @user_letter = UserLetter.create(params[:user_letter])
    flash[:notice] = "Successfully created user_letter." if @user_letter.save
    respond_with(@user_letter)
  end

  def destroy
    @user_letter = UserLetter.find(params[:id])   # нашли удаляемую связь
    @letter = Letter.find(@user_letter.letter_id) # запомнили письмо для этой удаляемой связи
    @user_letter.destroy   # удалили связь
    respond_with(@letter)  # вернулись в письмо
  end

end
