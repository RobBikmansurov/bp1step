class LettersController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update, :destroy, :register]
  before_action :set_letter, only: [:show, :edit, :update, :destroy, :register]
  helper_method :sort_column, :sort_direction
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @title_letter = 'Письма '
    if params[:user].present?
      user = User.find(params[:user])
      @letters = Letter.joins(:user_letter).where("user_letters.user_id = ?", params[:user])
      @title_letter += "исполнителя [ #{user.displayname} ]"
      if params[:status].present?
        @letters = @letters.where('letters.status = ?', params[:status])
        @title_letter += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
      else
        @letters = @letters.where('letters.status < 90', params[:status])
        @title_letter += " не завершенные"
      end
    else
      if params[:date].present? # письма за дату
        @letters = Letter.where(date: params[:date])
        @title_letter += 'за ' + params[:date]
      else
        if params[:regdate].present? # письма за дату регистрации
          @letters = Letter.where(regdate: params[:regdate])
          @title_letter += 'зарегистрированные ' + params[:regdate]
        else
          if params[:addresse].present? # письма от адресанта + письма алресату
            @letters = Letter.where('sender ILIKE ?', params[:addresse].strip)
            @title_letter += 'адреса[н]та ' + params[:addresse]
          else
            if params[:status].present?
              @letters = Letter.where('status = ?', params[:status])
              @title_letter += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
            else
              if params[:search].present?
                logger.debug "params: #{params[:search]}"
                @letters = Letter.search(params[:search]).includes(:user_letter, :letter_appendix)
              else
                @letters = Letter.search(params[:search]).where('status < 90').includes(:user_letter, :letter_appendix)
                @title_letter += 'не завершенные'
              end
            end
          end
        end
      end
    end
    unless params[:search].present?
      if params[:out].present?
        @letters = @letters.where('in_out <> 1')
        @title_letter += ' Исходящие'
      else
        @letters = @letters.where('in_out = 1')
        @title_letter += ' Входящие'
      end
    end
    @letters = @letters.order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    if @letter.letter_id
      @letter_link =  Letter.find(@letter.letter_id)
    end
    @letters_outgoing = Letter.where(letter_id: @letter.id).order('date DESC')  # исходящие из данного письма
    @requirements = Requirement.where(letter_id: @letter.id) # требования, созданные из письма
    respond_to do |format|
      format.html
      format.json { render json: @letter }
    end
  end

  def new
    @letter = Letter.new(in_out: 1, status: 0)
    @letter.sender = params[:addresse] if params[:addresse].present?
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 10.days).strftime("%d.%m.%Y") # срок исполнения - даем 10 дней по умолчанию
  end

  def edit
    @user_letter = UserLetter.new(letter_id: @letter.id)    # заготовка для ответственного
    @letter.author_id = current_user.id if @letter.author_id.blank? and user_signed_in?   # если автора нет - назначим первого, кто внес изменения
  end

  def create
    @letter = Letter.new(letter_params)
   if @letter.save
      redirect_to @letter, notice: 'Письмо создано.'
    else
      render action: 'new'
    end
  end

  def update
    if @letter.update(letter_params)
      @letter.result += "\r\n" + Time.current.strftime("%d.%m.%Y %H:%M:%S") + ": #{current_user.displayname} - " + params[:letter][:action] if params[:letter][:action].present?
      @letter.update_column(:result, "#{@letter.result}")
      # begin
      #   LetterMailer.update_letter(@letter, current_user, nil, '').deliver    # оповестим Исполнителей об изменении Письма
      # rescue  Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      #   flash[:alert] = "Error sending mail to responsible for the letter"
      # end
      redirect_to @letter, notice: 'Письмо сохранено.'
    else
      @user_letter = UserLetter.new(letter_id: @letter.id)
      render action: 'edit'
    end
  end

  def destroy
    @letter.destroy
    redirect_to letters_url, notice: 'Письмо удалено.'
  end

  def check
    @letters = Letter.where('status < 90 and duedate <= ?', Date.current + 1).order(:duedate)
    check_report
  end

  def clone
    letter = Letter.find(params[:id])   # письмо - прототип
    @letter = Letter.new(sender: letter.sender, in_out: letter.in_out, status: 0)
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 10.days).strftime("%d.%m.%Y") # срок исполнения - даем 10 дней по умолчанию
    @letter.source = letter.source
    @letter.subject = letter.subject
  end

  def create_outgoing
    letter = Letter.find(params[:id])   # входящее письмо
    @letter = Letter.new(sender: letter.sender, in_out: 2, letter_id: letter.id, status: 10, 
      date: Time.current.strftime("%d.%m.%Y"), number: 'б/н')
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 3.days).strftime("%d.%m.%Y") # срок исполнения - даем 3 дней по умолчанию
    @letter.source = letter.source
    @letter.subject = letter.subject
    @letter.result = "на #{letter.name}"
  end

  def create_requirement
    letter = Letter.find(params[:id])   # письмо - прототип
    @requirement = Requirement.new(letter_id: letter.id, author_id: current_user.id)
    #redirect_to requirements_new(@requirement) and return
    redirect_to proc { new_requirement_url(letter_id: letter.id) } and return
  end

  def create_user
    @letter = Letter.find(params[:id])
    @user_letter = UserLetter.new(letter_id: @letter.id)    # заготовка для ответственного
    render :create_user
    ##respond_with(@letter)
  end

  def update_user
    user_letter = UserLetter.new(params[:user_letter]) if params[:user_letter].present?
    if user_letter
      user_letter_clone = UserLetter.where(letter_id: user_letter.letter_id, user_id: user_letter.user_id).first  # проверим - нет такого исполнителя?
      if user_letter_clone
        user_letter_clone.status = user_letter.status
        user_letter = user_letter_clone
      end
      if user_letter.save
        flash[:notice] = "Исполнитель #{user_letter.user_name} назначен"
        begin
          UserLetterMailer.user_letter_create(user_letter, current_user).deliver_now    # оповестим нового исполнителя
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          flash[:alert] = "Error sending mail to #{user_letter.user.email}"
        end
        @letter = user_letter.letter   #Letter.find(@user_letter.letter_id)
        @letter.update_column(:status, 5) if @letter.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = "Ошибка - ФИО Исполнителя не указано."
    end
    respond_with(@letter)
  end

  def appendix_create
    @letter = Letter.find(params[:id])
    @letter_appendix = LetterAppendix.new(letter_id: @letter.id)
    render :appendix_create
  end

  def appendix_update
    @letter_appendix = LetterAppendix.new(params[:letter_appendix]) if params[:letter_appendix].present?
    if @letter_appendix
      @letter = @letter_appendix.letter
      if @letter_appendix.save
        flash[:notice] = 'Файл приложения "' + @letter_appendix.appendix_file_name  + '" загружен.'
      end
    else      
      flash[:alert] = "Ошибка - имя файла не указано."
    end
    respond_with(@letter_appendix.letter)
  end

  def log_week    # реестр регистрации
    if params[:week_day].present?
      d = params[:week_day].to_date
    else
      d = Date.current - 7  # по умолчанию - предыдущая неделя
    end
    week_start = d - d.days_to_week_start # начало недели отчета
    week_end = week_start + 6   # конец недели отчета
    @log_period = "с #{week_start.strftime("%d.%m.%Y")} по #{week_end.strftime("%d.%m.%Y")}"
    @week_number = "#{week_start.strftime("%Y-%m-%d")}"
    @letters = Letter.where('regdate > ? and regdate < ?', week_start - 1, week_end + 1).order(:regnumber)
    if params[:out].present?
      @letters = @letters.where('in_out <> 1')
      @in_out = 2
    else
      @letters = @letters.where('in_out = 1')
      @in_out = 1
    end

    if @letters.count > 0
      log_week_report
    else
      redirect_to letters_path, notice: "Нет зарегистрированных писем за период: #{week_start.strftime("%d.%m.%Y")} - #{week_end.strftime("%d.%m.%Y")}."
    end
  end

  def register
    len_regnumber = Letter.where('in_out = ? and regdate > ?', @letter.in_out, Time.current.beginning_of_year).maximum('length(regnumber)')  # длина строки наибольшего номера
    max_reg_number = Letter.where('in_out = ? and regdate > ? and length(regnumber) >= ?', @letter.in_out, Time.current.beginning_of_year, len_regnumber).maximum(:regnumber).to_i
    max_reg_number += 1   # next registration number for current year and directiom
    @letter.update(regnumber: max_reg_number, regdate: Date.current.strftime("%d.%m.%Y"))
    if @letter.in_out != 1  # это исходящее письмо
      if @letter.letter_id
        letter = Letter.find(@letter.letter_id)
        @letter.update(number: letter.number, date: letter.date) if letter
      end
    end
    redirect_to proc { letter_url(letter_id: @letter.id) } and return
  end

  def senders
    @title_senders = 'Корреспонденты (адресанты и адресаты), письма '
    if params[:status].present?
      @senders = Letter.select(:sender)..where('letters.status = ?', params[:status])
      @title_senders += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
    else
      @senders = Letter.select(:sender).where('letters.status < 90', params[:status])
      @title_senders += "не завершенные"
    end
    @senders = @senders.where('sender ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    _direction = params[:direction] || "asc"
    if _direction == 'asc'
      @senders = @senders.group(:sender, :status).order("sender DESC, status ASC").count
    else
      @senders = @senders.group(:sender, :status).order("sender ASC, status ASC").count
    end
    #@senders = @senders.paginate(:per_page => 10, :page => params[:page])
  end

  private
    def set_letter
      if params[:search].present? # это поиск
        @letters = Letter.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        render :index # покажем список найденного
      else
        @letter = Letter.find(params[:id])
      end
    end

    def letter_params
      params.require(:letter).permit(:regnumber, :regdate, :number, :date, :subject, :source, :sender, \
        :duedate, :body, :status, :status_name, :result, :letter_id, :author_id, :author_name, \
        :letter_appendix, :letter_id, :name, :appendix, :completion_date, :in_out)
    end

    def sort_column
      #params[:sort] || "date"
      params[:sort] || "id"   # вверху - самые новые письма
    end

    def sort_direction
      params[:direction] || "desc"
    end
  def record_not_found
    flash[:alert] = "Письмо ##{params[:id]} не найдено."
    redirect_to action: :index
  end

  def check_report    #  Отчет "Контроль исполнения"
    report = ODFReport::Report.new("reports/letters_check.odt") do |r|
      nn = 0
      r.add_field "REPORT_PERIOD", Date.current.strftime('%d.%m.%Y')
      r.add_field "WEEK_NUMBER", @week_number
      r.add_table("LETTERS", @letters, :header=>true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:id)
        t.add_column(:regnumber) do |letter|
          "#{letter.in_out == 1 ? 'Вх.№' : 'Исх.№'} #{letter.regnumber}"
        end
        t.add_column(:regdate) do |letter|
          "#{letter.regdate.strftime('%d.%m.%y')}" if letter.regdate
        end
        t.add_column(:number) do |letter|
          if letter.regnumber == letter.number
          else
            "#{letter.in_out == 1 ? 'Исх.№' : 'на №'} #{letter.number}"
          end
        end
        t.add_column(:date) do |letter|
          "от #{letter.date.strftime('%d.%m.%y')}"
        end
        t.add_column(:sender) do |letter|
          (letter.in_out == 1 ? '<=' : "=>") + "#{letter.sender}"
        end
        t.add_column(:subject)
        t.add_column(:author, :author_name)
        t.add_column(:source)
        t.add_column(:duedate) do |letter|
          days = letter.duedate - Date.current
          "#{letter.duedate.strftime('%d.%m.%y')}" + (days < 0 ? " (+ #{(-days).to_i} дн.)" : "")
        end
        t.add_column(:status) do |letter|
          LETTER_STATUS.key(letter.status)
        end
        t.add_column(:users) do |letter|  # исполнители
          s = ''
          letter.user_letter.each do |user_letter|
            s += ", " if !s.blank?
            s += user_letter.user.displayname
            s += '-отв.' if user_letter.status and user_letter.status > 0
          end
          "#{s}"
        end
        t.add_column(:result)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "letters_check.odt",
      :disposition => 'inline'    
  end

  def log_week_report    # реестр за неделю
    report = ODFReport::Report.new("reports/letters_reestr.odt") do |r|
      nn = 0
      #r.add_field "REPORT_DATE", Date.current.strftime('%d.%m.%Y')
      if @in_out == 1      # журнал воходящей корресподенции
        r.add_field "HEADER1", "Вх.№ и дата регистрации"
        r.add_field "HEADER2", "Исх.№ и дата"
        r.add_field "HEADER3", "Отправитель"
        r.add_field "IN_OUT_NAME", 'Входящей'
      else
        r.add_field "IN_OUT_NAME", 'Исходящей'
        r.add_field "HEADER1", "Исх.№ и дата регистрации"
        r.add_field "HEADER2", "На Вх.№ от даты"
        r.add_field "HEADER3", "Получатель"
      end
      r.add_field "WEEK_NUMBER", @week_number
      r.add_field "REPORT_PERIOD", @log_period
      r.add_table("TABLE_01", @letters, :header=>true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:id)
        t.add_column(:regnumber)
        t.add_column(:regdate) do |letter|
          "#{letter.regdate.strftime('%d.%m.%y')}"
        end
        t.add_column(:number)
        t.add_column(:date) do |letter|
          "#{letter.date.strftime('%d.%m.%y')}"
        end
        t.add_column(:sender)
        t.add_column(:subject)
        t.add_column(:author, :author_name)
        t.add_column(:source)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "letters_reestr.odt",
      :disposition => 'inline'    
  end

end
