# coding: utf-8
class DocumentsController < ApplicationController
  respond_to :odt, :only => :index
  respond_to :pdf, :only => :show
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :new]
  before_filter :get_document, :except => [:index, :print, :view, :update, :create]

  def index
    if params[:directive_id].present? # документы относящиеся к директиве
      @directive = Directive.find(params[:directive_id])
      @documents = @directive.document.paginate(:per_page => 10, :page => params[:page])
    else
      if params[:all].present?
        @documents = Document.order('cast (part as integer)', :name).all
      else
        if params[:place].present?  # список документов по месту хранения
          @documents = Document.where(:place => params[:place]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        else
          if params[:dlevel].present? #  список документов уровня
            @documents = Document.where(:dlevel => params[:dlevel]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
          else
            if params[:part].present? #  список документов раздела документооборота
              @documents = Document.where(:part => params[:part]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
            else
              if params[:status].present? #  список документов статуса
                ss = params[:status]
                @documents = Document.where(:status => ss).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
              else
                if params[:place].present? #  список документов, находящихся в одном месте
                  if params[:place].size == 0
                    @documents = Document.where("place = ''").order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
                  else
                    @documents = Document.where(:place => params[:place]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
                  end
                else
                  if params[:user].present? #  список документов пользователя
                    @user = User.find(params[:user])
                    @documents = Document.where(:owner_id => params[:user]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
                  else
                    if params[:tag].present?
                      @documents = Document.tagged_with(params[:tag]).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
                    else
                      @documents = Document.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    respond_to do |format|
      format.html
      format.odt { print }
      #format.pdf { print }
    end
  end

  def edit
    #authorize! :edit_document_place, @user if params[:user][:edit_document_place]
    @document_directives = DocumentDirective.where(:document_id => @document.id) # все связи документа с директивами
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    @document_bproces = BproceDocument.where(:document_id => @document.id)  # все ссылки на документ из процессов
    #@document_bproces = @document.bproce_document.all
    @document_bproce = @document.bproce_document.new # заготовка для новой связи с процессом
    respond_with(@document)
  end

  def update
    @document = Document.find(params[:id])
    flash[:notice] = "Successfully updated document."  if @document.update_attributes(document_params)
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    respond_with(@document)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf { view }
    end
    #respond_with(@document)
  end

  def new
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    #@document_bproce = @document.bproce_documents.new # заготовка для новой связи с процессом
    @document.owner_id = current_user.id if current_user  # владелец документа - пользователь
    @document.place = '?!'  # место хранения не определено
    respond_with(@document)
  end

  def create
    @document = Document.new(document_params)
    puts @document.inspect
    flash[:notice] = "Successfully created Document." if @document.save
    respond_with(@document)
  end

  def destroy
    flash[:notice] = "Successfully destroyed Document." if @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

private

  def document_params
    params.require(:document).permit(:document_file, :name, :dlevel, :description, :owner_name, :status, :approveorgan, :approved, :note, :place, :file_delete)
  end

  def print
    report = ODFReport::Report.new("reports/documents.odt") do |r|
      nn = 0  # порядковый номер документа
      nnp = 0
      first_part = 0  # номер раздела для сброса номера документа в разделе
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_table("TABLE_01", @documents, :header => true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:nnp) do |document|
          if first_part != document.part
            nnp = 0   # порядковый номер документа в разделе
            first_part = document.part
          end
          nnp += 1
          "#{nnp}"
        end
        t.add_column(:part)
        t.add_column(:name)
        t.add_column(:id, :id)
        t.add_column(:dlevel, :id)
        t.add_column(:organ, :approveorgan)
        t.add_column(:approved) do |document|   # дата утверждения в нормальном формате
          if document.approved
            "#{document.approved.strftime('%d.%m.%Y')}"
          end
        end

        t.add_column(:responsible) do |document|  # владелец документа, если задан
          if document.owner_id
            "#{document.owner.displayname}"
          end
        end
        t.add_column(:place)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "documents.odt",
      :disposition => 'inline' )
  end

  def view
    fname = "files" + @document.file_name         # добавим путь к файлам
    case File.extname(fname)  # определим по расширению файла его mime-тип
    when '.pdf'
      type = 'application/pdf'
    when '.doc'
      type = 'application/msword'
    else
      type = 'application/vnd.oasis.opendocument.text'
    end
    send_file(fname, :type => type, :filename => File.basename(@document.file_name), :disposition => 'inline' )
  end

  def get_document
    if params[:search].present? # это поиск
      @documents = Document.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      if params[:id].present?
        @document = Document.find(params[:id]) || not_found
      else
        @document = Document.new
      end
    end
  end

  def sort_column  
    params[:sort] || "name"
  end  
    
  def sort_direction  
    params[:direction] || "asc"  
  end  

end
