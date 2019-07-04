# frozen_string_literal: true

class DocumentsController < ApplicationController
  include Reports

  respond_to :odt, only: :index
  respond_to :pdf, only: :show
  respond_to :html
  respond_to :xml, :json, only: %i[index show]
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit new]
  before_action :set_document, except: %i[index print view create new]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @title_doc = 'Список документов'
    if params[:directive_id].present? # документы относящиеся к директиве
      @directive = Directive.find(params[:directive_id])
      @documents = @directive.document
    elsif params[:bproce_id].present?
      @title_doc = ''
      @bproce = Bproce.find(params[:bproce_id])
      ids = BproceDocument.where(bproce_id: @bproce.id).pluck(:document_id)
      @documents = Document.where(id: ids).all
      if params[:status].present? #  список документов, имеющих конкретный статус
        @documents = @documents.status(params[:status])
        @title_doc = " в статусе [#{params[:status]}]"
      end
    elsif params[:all].present?
      @title_doc = 'Каталог документов'
      @documents = Document.find_by_sql(<<-SQL.squish)
        SELECT documents.id, name, approveorgan, approved, place, status, part, owner_id, users.displayname
        FROM documents
        LEFT OUTER JOIN users
          ON (users.id=owner_id)
        WHERE NOT status = 'НеДействует'
        ORDER BY cast (part as integer), name
      SQL
    else
      @documents = Document.order(:name).all
      if params[:place].present? # список документов по месту хранения
        if params[:place].empty?
          @documents = @documents.where("place = ''")
          @title_doc += ' - место хранения оригинала [не указано]'
        else
          @documents = @documents.where(place: params[:place])
          @title_doc += ", хранящихся в [#{params[:place]}]: #{DOCUMENT_PLACE.key(params[:place])}"
        end
      elsif params[:dlevel].present? #  список документов уровня
        @documents = @documents.where(dlevel: params[:dlevel])
        @title_doc += " уровень [#{params[:dlevel]}]: #{DOCUMENT_LEVEL.key(params[:dlevel].to_i)}"
      else
        if params[:part].present? #  список документов раздела документооборота
          @documents = @documents.where(part: params[:part])
          @title_doc += " раздела [#{params[:part]}]"
        elsif params[:user].present? #  список документов пользователя
          @user = User.find(params[:user])
          @documents = Document.where(owner_id: params[:user])
          @title_doc += ', ответственный [' + @user.displayname + ']' if @user
        else
          if params[:tag].present?
            @title_doc += ", тэг [#{params[:tag]}]"
            @documents = @documents.tagged_with(params[:tag]).search(params[:search])
          end
          if params[:search].present?
            @title_doc += ", содержащих [#{params[:search]}]"
            @documents = @documents.full_search(params[:search])
          end
          if params[:status].present? #  список документов, имеющих конкретный статус
            @documents = @documents.status(params[:status])
            @title_doc += " в статусе [#{params[:status]}]"
          end
        end
      end
    end
    respond_to do |format|
      format.html do
        if params[:all].blank?
          @documents = @documents.order(sort_order(sort_column, sort_direction))
                                 .paginate(per_page: 10, page: params[:page])
        end
      end
      format.odt { print }
    end
  end

  def autocomplete
    @documents = Document.order(:name).where('name ilike ?', "%#{params[:term]}%")
    render json: @documents.map(&:name)
  end

  def edit
    # authorize! :edit_document_place, @user if params[:user][:edit_document_place]
    @document = Document.find(params[:id])
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    @document_bproce = @document.bproce_document.new # заготовка для новой связи с процессом
  end

  def update
    flash[:notice] = 'Документ успешно обновлен.' if @document.update(document_params)
    respond_with(@document)
  end

  def update_file
    if @document.update(document_file_params)
      flash[:notice] = "Загружен файл \"#{@document.document_file.original_filename}\""
    else
      flash[:alert] = "Ошибка: #{@document.errors.messages}"
    end
    respond_with(@document)
  end

  def add_favorite
    @user_document = UserDocument.new(user_id: current_user.id, document_id: @document.id, link: 10)
    flash[:notice] = "##{@document.id} добавлен в Избранное." if @user_document.save
    # избранные документы пользователя
    @user_documents = UserDocument.where(document_id: @document.id).order('link, updated_at DESC').includes(:user).load
    # respond_with @document, notice: "##{@document.id} добавлен в Избранное."
    redirect_to @document
  end

  def add_to_favorite
    @user_document = UserDocument.new(document_id: @document.id, link: 1)
    # render :add_to_favorite
  end

  def update_favorite
    if params[:user_document].present?
      user_id = User.where(displayname: params[:user_document][:user]).first.id
      @user_document = UserDocument.new(user_id: user_id, document_id: @document.id, link: params[:user_document][:link])
      flash[:notice] = "##{@document.id} добавлен в Избранное для #{params[:user_document][:user]}." if @user_document.save
      # избранные документы пользователя
      @user_documents = UserDocument.where(document_id: @document.id).order('link, updated_at DESC').includes(:user).load
    end
    redirect_to @document
  end

  def show
    @user_document = UserDocument.where(user_id: current_user.id, document_id: @document.id).first if current_user
    @user_documents = UserDocument.where(document_id: @document.id).order('link, updated_at DESC').load if current_user
    respond_to do |format|
      format.html
      format.pdf { view }
      format.json { render json: @document }
      format.xml { render xml: @document }
    end
  end

  def bproce_create
    @document = Document.find(params[:id])
    @bproce_document = @document.bproce_document.new
    render :bproce_create
  end

  def show_files; end

  def new
    @document = Document.new(dlevel: 3, status: 'Проект', place: '?!') # место хранения не определено
    if params[:id].present? # будем добавлять документ процесса
      @bproce = Bproce.find(params[:id])
      @document.bproce_id = @bproce.id
    end
    @document.owner_id = current_user.id if current_user # владелец документа - пользователь
  end

  def clone
    document = Document.find(params[:id]) # документ - прототип
    @document = Document.new(status: 'Проект') # новый документ
    @document.name = document.name
    @document.description = document.description
    @document.dlevel = document.dlevel
    @document.approveorgan = document.approveorgan
    @document.note = 'создан из #' + document.id.to_s
    @document.owner_id = current_user.id if current_user # владелец документа - пользователь
    @document.place = '?!' # место хранения не определено
    return unless @document.save

    flash[:notice] = 'Successfully cloned Document.' if @document.save
    document.bproce_document.find_each do |bp| # клонируем ссылки на процессы
      bproce_document = BproceDocument.new(document_id: @document, bproce_id: bp)
      bproce_document.document = @document
      bproce_document.bproce = bp.bproce
      bproce_document.purpose = bp.purpose
      bproce_document.save
    end
    document.document_directive.find_each do |document_directive| # клонируем ссылки на директивы
      new_document_directive = DocumentDirective.new(document_id: @document.id, directive_id: document_directive.directive_id,
                                                     note: document_directive.note)
      new_document_directive.save
    end
  end

  def create
    @document = Document.new(document_params)
    @document.owner_id = current_user.id if current_user # владелец документа - пользователь
    if @document.save
      flash[:notice] = 'Документ создан'
      bproce = Bproce.find(@document.bproce_id) if @document.bproce_id # добавляем документ из процесса?
      if bproce
        # привязали документ к процессу
        bproce_document = BproceDocument.new(document_id: @document, bproce_id: bproce)
        bproce_document.document = @document
        bproce_document.bproce = bproce
        flash[:notice] = "Создан документ процесса ##{bproce.id}" if bproce_document.save
      end
      redirect_to document_path(@document)
    else
      render :new
    end
  end

  def destroy
    flash[:notice] = 'Документ удален' if @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

  def file_delete
    @document.document_file = nil
    flash[:notice] = 'Файл документа удален' if @document.save
    # render :show
    render :file_delete
  end

  def file_create
    render :file_create
  end

  def pdf_create
    render :pdf_create
  end

  def update_pdf
    pdf_file = document_file_params[:document_file]
    if File.extname(pdf_file.original_filename) == '.pdf'
      File.open(@document.pdf_path, 'wb') do |file|
        file.write(pdf_file.read)
      end
      flash[:notice] = "Загружен PDF \"#{@document.document_file.original_filename}\""
    else
      flash[:alert] = "Неверный файл '#{pdf_file.original_filename}'! Разрешен тип *.PDF"
    end
    respond_with(@document)
  end

  def directive_create
    render :_form_directive
  end

  def approval_sheet
    approval_sheet_odt
  end

  private

  def document_params
    params.require(:document)
          .permit(:name, :dlevel, :description, :owner_name, :status, :approveorgan, :approved,
                  :note, :place, :file_delete, :bproce_id, :document_file)
  end

  def document_file_params
    params.require(:document).permit(:document_file)
  end

  def user_document_params
    params.require(:user_document).permit(:document_id, :user_id, :link)
  end

  def print
    report = ODFReport::Report.new('reports/documents.odt') do |r| # rubocop:disable Metrics/BlockLength
      nn = 0 # порядковый номер документа
      nnp = 0
      first_part = 0 # номер раздела для сброса номера документа в разделе
      # @title_doc = '' if !@title_doc
      @title_doc += '  стр.' + params[:page] if params[:page].present?
      r.add_field 'REPORT_TITLE', @title_doc
      r.add_table('TABLE_01', @documents, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:nnp) do |document|
          unless first_part == document.part
            nnp = 0 # порядковый номер документа в разделе
            first_part = document.part
          end
          nnp += 1
          nnp.to_s
        end
        t.add_column(:part)
        t.add_column(:name)
        t.add_column(:id, :id)
        t.add_column(:dlevel, :id)
        t.add_column(:organ, :approveorgan)
        t.add_column(:approved) do |document| # дата утверждения в нормальном формате
          document.approved.strftime('%d.%m.%Y').to_s if document.approved
        end
        if params[:all].present?
          t.add_column(:responsible, :displayname) # владелец документа, если задан
        else
          t.add_column(:responsible) do |document| # владелец документа, если задан
            document.owner.displayname.to_s if document.owner_id
          end
        end

        t.add_column(:place)
      end
    end
    report_footer report
    send_data report.generate, type: 'application/msword',
                               filename: 'documents.odt',
                               disposition: 'inline'
  end

  def view
    fname = 'files' + @document.file_name # добавим путь к файлам
    type = case File.extname(fname) # определим по расширению файла его mime-тип
           when '.pdf'
             'application/pdf'
           when '.doc'
             'application/msword'
           else
             'application/vnd.oasis.opendocument.text'
           end
    send_file(fname, type: type, filename: File.basename(@document.file_name), disposition: 'inline')
  end

  def approval_sheet_odt
    report = ODFReport::Report.new('reports/approval-sheet.odt') do |r| # rubocop:disable Metrics/BlockLength
      r.add_field 'REPORT_DATE', Time.zone.today.strftime('%d.%m.%Y')
      r.add_field 'REPORT_DATE1', (Time.zone.today + 10.days).strftime('%d.%m.%Y')
      r.add_field :id, @document.id
      r.add_field :name, @document.name
      r.add_field :description, @document.description
      r.add_field :approve_organ, @document.approveorgan
      r.add_field :document_owner, @document.owner_name
      rr = 0
      # if @document.bproce.present? # есть ссылки из документа на другие процессы?
      if BproceDocument.where(document_id: @document.id).any? # есть ссылки из документа на другие процессы?
        r.add_field :bp, 'Относится к процессам:'
        r.add_table('BPROCS', @document.bproce_document.all, header: false, skip_if_empty: true) do |t|
          t.add_column(:rr) do |_n1| # порядковый номер строки таблицы
            rr += 1
          end
          t.add_column(:process_name) do |bp|
            bp.bproce.name
          end
          t.add_column(:process_id) do |bp|
            bp.bproce.id
          end
          t.add_column(:process_owner) do |bp|
            bp.bproce.user_name
          end
        end
      else
        r.add_field :bp, 'Процесс не назначен!'
      end
      r.add_field :user_position, current_user.position.mb_chars.capitalize.to_s
      r.add_field :user_name, current_user.displayname
    end
    # report_file_name = report.generate
    send_data report.generate, type: 'application/msword',
                               filename: "d#{@document.id}-approval-sheet.odt",
                               disposition: 'inline'
  end

  def set_document
    if params[:search].present? # это поиск
      @documents = Document.full_search(params[:search]).order(sort_order(sort_column, sort_direction))
                           .paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    elsif params[:id].present?
      @document = Document.find(params[:id])
    else
      @document = Document.new
    end
  end

  def record_not_found
    flash[:alert] = 'Неверный #id, Документ не найден.'
    redirect_to action: :index
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end
end
