# coding: utf-8
class DocumentsController < ApplicationController
  respond_to :odt, :only => :index
  respond_to :pdf, :only => :show
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :get_document, :except => [:index, :print, :view]

  #autocomplete :user, :displayname

  def index
    if params[:directive_id].present? # документы относящиеся к директиве
      @directive = Directive.find(params[:directive_id])
      @documents = @directive.document.paginate(:per_page => 10, :page => params[:page])
    else
      if params[:all].present?
        @documents = Document.order(:part, :name).all
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
                  @documents = Document.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
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
    @document_directives = DocumentDirective.find_all_by_document_id(@document) # все связи документа с директивами
    @document_directive = @document.document_directive.new # заготовка для новой связи с директивой
    respond_with(@document)
  end

  def update
    #user_id = @document.owner_id
    uploaded_file = params[:document][:uploaded_file] # информация о загруженном файле
    logger.debug "owner_id= #{@document.owner_id}"
    #if !uploaded_file.nil?
    #  logger.debug "uploaded_file = #{uploaded_file.inspect}"
    #  logger.debug "headers = #{uploaded_file.headers}"
    #  params[:document][:eplace] = uploaded_file.original_filename
    #end
    flash[:notice] = "Successfully updated document."  if @document.update_attributes(params[:document])
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
    respond_with(@document)
  end

  def create
    @document = Document.new(params[:document])
    flash[:notice] = "Successfully created Document." if @document.save
    respond_with(@document)
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

private  

  def print
    report = ODFReport::Report.new("reports/documents.odt") do |r|
      nn = 0  # порядковый номер строки
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_table("TABLE_01", @documents, :header => true) do |t|
        t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name)
        t.add_column(:organ, :approveorgan)
        t.add_column(:approved) do |document|   # дата утверждения в нормальном формате
          if document.approved
            "#{document.approved.strftime('%d.%m.%Y')}"
          end
        end

        t.add_column(:responsible) do |document|  # владелец документа, если задан
          if document.owner_id
            #u=User.find(document.owner_id)
            #{}"#{u.displayname}"
            "#{document.owner.displayname}"
          end
        end

        #t.add_column(:responsible) do |ca|
          #u = User.find(@documents[responsible]).displayname
          #"#{u}"
        #end
        #t.add_column(:eplace, @docs.name)
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
      @document = params[:id].present? ? Document.find(params[:id]) : Document.new
    end
  end

  def sort_column  
    params[:sort] || "name"
  end  
    
  def sort_direction  
    params[:direction] || "asc"  
  end  

end
