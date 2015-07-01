class LettersController < ApplicationController
  respond_to :html, :json
  before_action :set_letter, only: [:show, :edit, :update, :destroy]

  def index
    @letters = Letter.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page])
  end

  def show
  end

  def new
    @letter = Letter.new
    @letter.duedate = (Time.current + 10.days).strftime("%d.%m.%Y") # срок исполнения - даем 10 дней по умолчанию
  end

  def edit
    @user_letter = UserLetter.new(letter_id: @letter.id)
  end

  def create
    @letter = Letter.new(letter_params)

    if @letter.save
      redirect_to @letter, notice: 'Letter was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @letter.update(letter_params)
      redirect_to @letter, notice: 'Letter was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @letter.destroy
    redirect_to letters_url, notice: 'Letter was successfully destroyed.'
  end

  def clone
    letter = Letter.find(params[:id])   # письмо - прототип
    @letter = Letter.new(sender: letter.sender)
    @letter.duedate = (Time.current + 10.days).strftime("%d.%m.%Y") # срок исполнения - даем 10 дней по умолчанию
    @letter.source = letter.source
  end

  def record_not_found
    flash[:alert] = "Неверный #id - нет такого письма."
    redirect_to action: :index
  end

  def appendix_create
    @letter = Letter.find(params[:id])
    @letter_appendix = LetterAppendix.new(letter_id: @letter.id)
    render :appendix_create
  end

  def appendix_update
    letter_appendix = LetterAppendix.new(params[:letter_appendix]) if params[:letter_appendix].present?
    if letter_appendix
      @letter = letter_appendix.letter
      if letter_appendix.name.blank?
        flash[:alert] = 'Ошибка - не указано наименование файла приложения!'
      else
        flash[:notice] = 'Файл приложения "' + letter_appendix.name  + '" загружен.' if letter_appendix.save
      end
    else      
      flash[:alert] = "Ошибка - имя файла не указано."
    end
    respond_with(letter_appendix.letter)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_letter
      @letter = Letter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def letter_params
      params.require(:letter).permit(:regnumber, :regdate, :number, :date, :subject, :source, :sender, :duedate, :body, :status, :result, :letter_id)
    end

    def sort_column
      params[:sort] || "date"
    end

    def sort_direction
      params[:direction] || "desc"
    end

end
