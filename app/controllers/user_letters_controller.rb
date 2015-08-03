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
    @user_letter = UserLetter.new(params[:user_letter])
    if @user_letter.save
      flash[:notice] = "Successfully created user_letter."
      begin
        UserLetterMailer.user_letter_create(@user_letter, current_user).deliver    # оповестим нового исполнителя
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to #{@user_letter.user.email}"
      end
      letter = Letter.find(@user_letter.letter_id)
      letter.update_column(:status, 5) if letter.status < 1 # если есть ответственные - статус = Назначено
    end
    respond_with(@user_letter)
  end

  def destroy
    @user_letter = UserLetter.find(params[:id])   # нашли удаляемую связь
    @letter = Letter.find(@user_letter.letter_id) # запомнили письмо для этой удаляемой связи
    begin
      UserLetterMailer.user_letter_destroy(@user_letter, current_user).deliver_now    # оповестим исполнителя
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:alert] = "Error sending mail to #{@user_letter.user.email}"
    end
    if @user_letter.destroy   # удалили связь
      @letter.update_column(:status, 0) if !@letter.user_letter.first # если нет ответственных - статус = Новое
    end
    respond_with(@letter)  # вернулись в письмо
  end

end
