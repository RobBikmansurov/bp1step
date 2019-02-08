# frozen_string_literal: true

class LettersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, only: %i[edit new create update destroy register show]
  before_action :set_letter, only: %i[show edit update destroy register reestr]
  helper_method :sort_column, :sort_direction
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rubocop:disable Metrics/LineLength
  def index
    @title_letter = 'Письма '
    if params[:user].present?
      user = User.find(params[:user])
      @letters = Letter.joins(:user_letter).where('user_letters.user_id = ?', params[:user])
      @title_letter += "исполнителя [ #{user.displayname} ]"
      if params[:status].present?
        @letters = @letters.status(params[:status])
        @title_letter += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
      else
        @letters = @letters.where('letters.status < 90', params[:status])
        @title_letter += ' не завершенные'
      end
    elsif params[:date].present? # письма за дату
      @letters = Letter.where(date: params[:date])
      @title_letter += 'за ' + params[:date]
    elsif params[:regdate].present? # письма за дату регистрации
      @letters = Letter.where(regdate: params[:regdate])
      @title_letter += 'зарегистрированные ' + params[:regdate]
    elsif params[:addresse].present? # письма от адресанта + письма адресату
      @letters = Letter.where('sender ILIKE ?', params[:addresse].strip)
      @title_letter += 'адреса[н]та ' + params[:addresse]
    elsif params[:status].present?
      @letters = Letter.status(params[:status])
      @title_letter += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
    elsif params[:search].present?
      @letters = Letter.search(params[:search]).includes(:user_letter, :letter_appendix)
    else
      @letters = Letter.search(params[:search]).where('status < 90').includes(:user_letter, :letter_appendix)
      @title_letter += 'не завершенные'
    end
    if params[:search].blank?
      if params[:out].present?
        @letters = @letters.where('in_out <> 1')
        @title_letter += ' Исходящие'
      else
        @letters = @letters.where('in_out = 1')
        @title_letter += ' Входящие'
      end
    end
    @letters = @letters.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
  end

  def show
    @letter_link = Letter.find(@letter.letter_id) if @letter.letter_id
    @letters_outgoing = Letter.where(letter_id: @letter.id).order('date DESC') # исходящие из данного письма
    @requirements = Requirement.where(letter_id: @letter.id) # требования, созданные из письма
    @tasks = Task.where(letter_id: @letter.id) # задачи, созданные из письма
    respond_to do |format|
      format.html
      format.json { render json: @letter }
    end
  end

  def new
    @letter = Letter.new(in_out: 1, status: 0)
    @letter.sender = params[:addresse] if params[:addresse].present?
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 10.days).strftime('%d.%m.%Y') # срок исполнения - даем 10 дней по умолчанию
  end

  def edit
    @user_letter = UserLetter.new(letter_id: @letter.id) # заготовка для ответственного
    # если автора нет - назначим первого, кто внес изменения
    @letter.author_id = current_user.id if @letter.author_id.blank? && user_signed_in?
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
    status_was = @letter.status # старые значения
    if @letter.update(letter_params)
      @letter.result += "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} - " + params[:letter][:action] if params[:letter][:action].present?
      if @letter.status >= 90 && status_was < 90 # стало завершено
        @letter.result += "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} считает, что все работы по письму исполнены"
      elsif @letter.status < 90 && status_was >= 90 # стало не завершено, а было завершено
        @letter.result += "\r\n" + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ": #{current_user.displayname} считает, что работы по письму надо продолжить"
      end
      if params[:letter][:action].present? || (status_was != @letter.status)
        @letter.update_column(:result, @letter.result.to_s)
        @letter.update_column(:status, 10) if @letter.status < 10 # на исполнении, если Назначено или Новое
      end
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
    letter = Letter.find(params[:id]) # письмо - прототип
    @letter = Letter.new(sender: letter.sender, in_out: letter.in_out, status: 0)
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 10.days).strftime('%d.%m.%Y') # срок исполнения - даем 10 дней по умолчанию
    @letter.source = letter.source
    @letter.subject = letter.subject
  end

  def create_outgoing
    letter = Letter.find(params[:id]) # входящее письмо
    @letter = Letter.new(sender: letter.sender, in_out: 2, letter_id: letter.id, status: 10,
                         date: Time.current.strftime('%d.%m.%Y'), number: 'б/н')
    @letter.author_id = current_user.id if user_signed_in?
    @letter.duedate = (Time.current + 3.days).strftime('%d.%m.%Y') # срок исполнения - даем 3 дней по умолчанию
    @letter.source = letter.source
    @letter.subject = letter.subject
    @letter.result = "это ответ на #{letter.name} (##{letter.id})"
  end

  def create_requirement
    letter = Letter.find(params[:id]) # письмо - прототип
    @requirement = Requirement.new(letter_id: letter.id, author_id: current_user.id)
    # redirect_to requirements_new(@requirement) and return
    redirect_to(new_requirement_url(letter_id: letter.id)) && return
  end

  def create_task
    parent_letter = Letter.find(params[:id])
    redirect_to(new_task_url(letter_id: parent_letter.id)) && return
  end

  def create_user
    @letter = Letter.find(params[:id])
    @user_letter = UserLetter.new(letter_id: @letter.id) # заготовка для ответственного
    render :create_user
    # #respond_with(@letter)
  end

  def update_user
    user_letter = UserLetter.new(user_letter_params) if params[:user_letter].present?
    if user_letter
      @letter = user_letter.letter
      if @letter.users.any? # уже есть исполнители письма
        if UserLetter.where(letter_id: @letter.id, user_id: user_letter.user_id).any?
          _status = user_letter.status
          user_letter = UserLetter.where(letter_id: user_letter.letter_id, user_id: user_letter.user_id).first
          user_letter.status = _status # новый статус для исполнителя, котрый уже был
        end
        user_letter.status = check_statuses_another_users(user_letter)
      else
        user_letter.status = 1 # первый исполнитель - ответственный
      end
      p user_letter
      p user_letter.status
      if user_letter.save
        flash[:notice] = "#{user_letter.user_name} назначен #{user_letter.status > 0 ? 'отв.' : ''} исполнителем"
        UserLetterMailer.user_letter_create(user_letter, current_user).deliver_later # оповестим нового исполнителя
        @letter = user_letter.letter # Letter.find(@user_letter.letter_id)
        @letter.update_column(:status, 5) if @letter.status < 1 # если есть ответственные - статус = Назначено
      end
    else
      flash[:alert] = 'Ошибка - ФИО Исполнителя не указано.'
    end
    respond_with(@letter)
  end

  def appendix_create
    @letter = Letter.find(params[:id])
    @letter_appendix = LetterAppendix.new(letter_id: @letter.id)
    render :appendix_create
  end

  def appendix_update
    @letter_appendix = LetterAppendix.new(letter_appendix_params) if params[:letter_appendix].present?
    if @letter_appendix
      @letter = @letter_appendix.letter
      flash[:notice] = 'Файл приложения "' + @letter_appendix.appendix_file_name + '" загружен.' if @letter_appendix.save
    else
      flash[:alert] = 'Ошибка - имя файла не указано.'
    end
    respond_with(@letter_appendix.letter)
  end

  # реестр регистрации
  def log_week
    d = if params[:week_day].present?
          params[:week_day].to_date
        else
          Date.current - 7 # по умолчанию - предыдущая неделя
        end
    week_start = d - d.days_to_week_start # начало недели отчета
    week_end = week_start + 6 # конец недели отчета
    @log_period = "с #{week_start.strftime('%d.%m.%Y')} по #{week_end.strftime('%d.%m.%Y')}"
    @week_number = week_start.strftime('%Y-%m-%d').to_s
    @letters = Letter.where('regdate > ? and regdate < ?', week_start - 1, week_end + 1).order(:regnumber)
    if params[:out].present?
      @letters = @letters.where('in_out <> 1')
      @in_out = 2
    else
      @letters = @letters.where('in_out = 1')
      @in_out = 1
    end
    if @letters.any?
      log_week_report
    else
      redirect_to letters_path, alert: "Нет зарегистрированных писем за период: #{week_start.strftime('%d.%m.%Y')} - #{week_end.strftime('%d.%m.%Y')}."
    end
  end

  # реестр
  def reestr
    @letters = Letter.where('sender ILIKE ? and regdate = ?', @letter.sender, @letter.regdate).order(:regnumber)
    @sender = @letter.sender
    reestr_report
  end

  def register
    len_regnumber = Letter.where('in_out = ? and regdate > ?', @letter.in_out, Time.current.beginning_of_year).maximum('length(regnumber)') # длина строки наибольшего номера
    max_reg_number = Letter.where('in_out = ? and regdate > ? and length(regnumber) >= ?', @letter.in_out, Time.current.beginning_of_year, len_regnumber).maximum(:regnumber).to_i
    max_reg_number += 1 # next registration number for current year and directiom
    @letter.update(regnumber: max_reg_number, regdate: Date.current.strftime('%d.%m.%Y'))
    if @letter.in_out != 1 # это исходящее письмо
      if @letter.letter_id
        letter = Letter.find(@letter.letter_id)
        @letter.update(number: letter.number, date: letter.date) if letter
      end
    end
    redirect_to(letter_url(letter_id: @letter.id)) && return
  end

  def senders
    @title_senders = 'Корреспонденты (адреса[н]ты), письма '
    if params[:status].present?
      @senders = Letter.select(:sender).where('letters.status = ?', params[:status])
      @title_senders += "в статусе [ #{LETTER_STATUS.key(params[:status].to_i)} ]"
    else
      @senders = Letter.select(:sender).where('letters.status < 90', params[:status])
      @title_senders += 'не завершенные'
    end
    if params[:addresse].present? # письма от адресанта + письма алресату
      @senders = @senders.where('sender ILIKE ?', params[:addresse].strip)
      @title_senders += 'адреса[н]та ' + params[:addresse]
    elsif params[:search].present?
      @senders = @senders.where('sender ILIKE ?', "%#{params[:search]}%")
    end
    direction = params[:direction] || 'asc'
    @senders = if direction == 'asc'
                 @senders.group(:sender, :status).order('sender DESC, status ASC').size
               else
                 @senders.group(:sender, :status).order('sender ASC, status ASC').size
               end
    # @senders = @senders.paginate(:per_page => 10, :page => params[:page])
  end

  private

  def set_letter
    if params[:search].present? # это поиск
      @letters = Letter.search('?', params[:search])
                       .order(sort_order(sort_column, sort_direction))
                       .paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @letter = Letter.find(params[:id])
    end
  end

  def letter_params
    params.require(:letter)
          .permit(:regnumber, :regdate, :number, :date, :subject, :source, :sender,
                  :duedate, :body, :status, :status_name, :result, :letter_id, :author_id, :author_name,
                  :letter_appendix, :letter_id, :name, :appendix, :completion_date, :in_out)
  end

  def letter_appendix_params
    params.require(:letter_appendix).permit(:letter_id, :name, :appendix)
  end

  def user_letter_params
    params.require(:user_letter)
          .permit(:user_id, :letter_id, :status, :user_name)
  end

  def sort_column
    params[:sort] || 'id' # вверху - самые новые письма
  end

  def sort_direction
    params[:direction] || 'desc'
  end

  def record_not_found
    flash[:alert] = "Письмо ##{params[:id]} не найдено."
    redirect_to action: :index
  end

  # Отчет "Контроль исполнения"
  def check_report
    report = ODFReport::Report.new('reports/letters_check.odt') do |r|
      nn = 0
      r.add_field 'REPORT_PERIOD', Date.current.strftime('%d.%m.%Y')
      r.add_field 'WEEK_NUMBER', @week_number
      r.add_table('LETTERS', @letters, header: true) do |t|
        t.add_column(:nn) do |_n1|
          nn += 1
        end
        t.add_column(:id)
        t.add_column(:regnumber) do |letter|
          "#{letter.in_out == 1 ? 'Вх.№' : 'Исх.№'} #{letter.regnumber}"
        end
        t.add_column(:regdate) do |letter|
          letter.regdate&.strftime('%d.%m.%y')
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
          (letter.in_out == 1 ? '<=' : '=>') + letter.sender.to_s
        end
        t.add_column(:subject)
        t.add_column(:author, :author_name)
        t.add_column(:source)
        t.add_column(:duedate) do |letter|
          days = letter.duedate - Date.current
          letter.duedate.strftime('%d.%m.%y') + (days.negative? ? " (+ #{-days} дн.)" : '')
        end
        t.add_column(:status) do |letter|
          LETTER_STATUS.key(letter.status)
        end
        t.add_column(:users) do |letter| # исполнители
          s = ''
          letter.user_letter.find_each do |user_letter|
            s += ', ' if s.present?
            s += user_letter.user.displayname
            s += '-отв.' if user_letter.status&.positive?
          end
          s.to_s
        end
        t.add_column(:result)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'letters_check.odt',
                               disposition: 'inline'
  end

  # реестр за неделю
  def log_week_report
    report = ODFReport::Report.new('reports/letters_reestr.odt') do |r|
      nn = 0
      # r.add_field "REPORT_DATE", Date.current.strftime('%d.%m.%Y')
      if @in_out == 1 # журнал входящей корресподенции
        r.add_field 'HEADER1', 'Вх.№ и дата регистрации'
        r.add_field 'HEADER2', 'Исх.№ и дата'
        r.add_field 'HEADER3', 'Отправитель'
        r.add_field 'IN_OUT_NAME', 'Входящей'
      else
        r.add_field 'IN_OUT_NAME', 'Исходящей'
        r.add_field 'HEADER1', 'Исх.№ и дата регистрации'
        r.add_field 'HEADER2', 'На Вх.№ от даты'
        r.add_field 'HEADER3', 'Получатель'
      end
      r.add_field 'WEEK_NUMBER', @week_number
      r.add_field 'REPORT_PERIOD', @log_period
      r.add_table('TABLE_01', @letters, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:id)
        t.add_column(:regnumber)
        t.add_column(:regdate) do |letter|
          letter.regdate.strftime('%d.%m.%y').to_s
        end
        t.add_column(:number)
        t.add_column(:date) do |letter|
          letter.date.strftime('%d.%m.%y').to_s
        end
        t.add_column(:sender)
        t.add_column(:subject)
        t.add_column(:author, :author_name)
        t.add_column(:source)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'letters_reestr.odt',
                               disposition: 'inline'
  end

  # реестр исходящих
  def reestr_report
    report = ODFReport::Report.new('reports/reestr.odt') do |r|
      nn = 0
      r.add_field 'REPORT_DATE', "#{Date.current.strftime('%d.%m.%Y')} г."
      r.add_field 'SENDER', @sender
      r.add_table('TABLE_01', @letters, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:regnumber)
        t.add_column(:regdate) do |letter|
          letter.regdate&.strftime('%d.%m.%Y').to_s
        end
        t.add_column(:naim, :subject)
      end
      r.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'reestr.odt',
                               disposition: 'inline'
  end

  # проверить чтобы ответственный был только один для данного письма
  def check_statuses_another_users(user_letter)
    other_users = UserLetter.where(letter_id: user_letter.letter_id).where.not(user_id: user_letter.user_id).where('status > 0')
    if user_letter.status > 0
      if other_users.any?
        other_users.first.update_column(:status, 0)
      end
    else
      unless other_users.any? # нет других отвественных
        user_letter.status = 1
      end
    end
    user_letter.status
  end
end
