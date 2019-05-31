# frozen_string_literal: true

class IresourcesController < ApplicationController
  include Reports

  respond_to :html
  respond_to :pdf, :odf, :xml, :json, only: :index
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit update new create]
  before_action :iresource, except: [:index]

  def index
    @iresources = Iresource.order(:label)
    if params[:all].blank?
      iresources = Iresource.order(sort_order(sort_column, sort_direction))
      iresources = iresources.where(level: params[:level]) if params[:level].present?
      iresources = iresources.where(risk_category: params[:risk]) if params[:risk].present?
      if params[:user].present? #  список ресурсов пользователя
        @user = User.find(params[:user])
        iresources = iresources.where(user_id: params[:user])
      end
      iresources = iresources.search(params[:search]) if params[:search].present?
      @iresources = iresources.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
    end
    respond_to do |format|
      format.html
      format.pdf { print }
      format.json { render json: @iresources, except: %i[created_at updated_at] }
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
    @bproce_iresource = BproceIresource.new(iresource_id: @iresource.id) # заготовка для новой связи с процессом
    @iresource = Iresource.find(params[:id])
  end

  def create
    @iresource = Iresource.new(iresource_params)
    respond_to do |format|
      if @iresource.save
        format.html { redirect_to @iresource, notice: 'Iresource was successfully created.' }
        format.json { render json: @iresource, status: :created, location: @iresource }
      else
        format.html { render action: 'new' }
        format.json { render json: @iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @bproce_iresource = BproceIresource.new(iresource_id: @iresource.id) # заготовка для новой связи с процессом
    respond_to do |format|
      if @iresource.update(iresource_params)
        format.html { redirect_to @iresource, notice: 'Iresource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @iresource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    flash[:notice] = 'Successfully destroyed iresource.' if @iresource.destroy
    respond_to do |format|
      format.html { redirect_to iresources_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @iresources = Iresource.order(:label).where('label ilike ? or location ilike ?', "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @iresources.map(&:label)
  end

  def print
    report = ODFReport::Report.new('reports/iresources.odt') do |r|
      nn = 0
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_table('TABLE_01', @iresources, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:label)
        t.add_column(:location)
        t.add_column(:alocation)
        t.add_column(:access_read)
        t.add_column(:access_write)
        t.add_column(:access_other)
        t.add_column(:risk_category)
        t.add_column(:note)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'resources.odt',
                               disposition: 'inline'
  end

  private

  def iresource_params
    params.require(:iresource).permit(:level, :label, :location, :alocation, :volume, :note,
                                      :access_read, :access_write, :access_other, :risk_category,
                                      :user_id, :owner_name)
  end

  def sort_column
    params[:sort] || 'label'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def iresource
    if params[:search].present? # это поиск
      iresources = Iresource.search(params[:search])
      @iresources = iresources.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @iresource = params[:id].present? ? Iresource.find(params[:id]) : Iresource.new
    end
  end
end
