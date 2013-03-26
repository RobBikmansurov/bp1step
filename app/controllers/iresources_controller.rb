class IresourcesController < ApplicationController
  respond_to :html
  helper_method :sort_column, :sort_direction
  before_filter :get_iresource, :except => [:index]

  def index
    if params[:all].present?
      @iresources = Iresource.all
    else
      if params[:level].present?
        @iresources = Iresource.where(:level => params[:level]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        if params[:risk].present?
          @iresources = Iresource.where(:risk_category => params[:risk]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        else
          @iresources = Iresource.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
        end
      end
    end
    respond_to do |format|
      format.html
      format.pdf { print }
      format.json { render json: @iresources }
    end
  end

  def show
    respond_with(@iresource = Iresource.find(params[:id]))
  end

  def new
    @bproce_iresource = BproceIresource.new
    respond_with(@iresource)
  end

  def edit
    @bproce_iresource = BproceIresource.new(:iresource_id => @iresource.id) # заготовка для новой связи с процессом
    @iresource = Iresource.find(params[:id])
  end

  def create
    @iresource = Iresource.new(params[:iresource])

    respond_to do |format|
      if @iresource.save
        format.html { redirect_to @iresource, notice: 'Iresource was successfully created.' }
        format.json { render json: @iresource, status: :created, location: @iresource }
      else
        format.html { render action: "new" }
        format.json { render json: @iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /iresources/1
  # PUT /iresources/1.json
  def update
    @iresource = Iresource.find(params[:id])

    respond_to do |format|
      if @iresource.update_attributes(params[:iresource])
        format.html { redirect_to @iresource, notice: 'Iresource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iresources/1
  # DELETE /iresources/1.json
  def destroy
    @iresource = Iresource.find(params[:id])
    @iresource.destroy

    respond_to do |format|
      format.html { redirect_to iresources_url }
      format.json { head :no_content }
    end
  end

  def print
    report = ODFReport::Report.new("reports/iresources.odt") do |r|
      nn = 0
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_table("TABLE_01", @iresources, :header=>true) do |t|
      t.add_column(:nn) do |ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:label)
        t.add_column(:location)
        t.add_column(:access_read)
        t.add_column(:access_write)
        t.add_column(:access_other)
        t.add_column(:risk_category)
        t.add_column(:note)
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    report_file_name = report.generate
    send_file(report_file_name,
      :type => 'application/msword',
      :filename => "resources.odt",
      :disposition => 'inline' )
  end


private
  def sort_column
    params[:sort] || "label"
  end

  def sort_direction
    params[:direction] || "asc"
  end
  
  def get_iresource
    if params[:search].present? # это поиск
      @iresources = Iresource.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @iresource = params[:id].present? ? Iresource.find(params[:id]) : Iresource.new
    end
  end
end
