# frozen_string_literal: true

class BappsController < ApplicationController
  include Reports
  respond_to :html
  respond_to :pdf, :odf, :xml, :json, only: :index
  helper_method :sort_column, :sort_direction
  before_action :set_app, only: %i[show destroy update edit new]
  before_action :authenticate_user!, only: %i[edit new]

  autocomplete :bproce, :name, extra_data: [:id]

  def index
    if params[:bproce_id].present? # это приложения выбранного процесса
      @bp = Bproce.find(params[:bproce_id]) # информация о процессе
      @bproce_bapps = @bp.bproce_bapps.paginate(per_page: 10, page: params[:page])
    elsif params[:all].present?
      @bapps = Bapp.order(:name)
    else
      bapps = Bapp.all
      bapps = bapps.searchtype(params[:apptype]) if params[:apptype].present?
      bapps = bapps.tagged_with(params[:tag]) if params[:tag].present?
      bapps = bapps.search(params[:search]) if params[:search].present?
      @bapps = bapps.order(sort_order(sort_column, sort_direction)).paginate(per_page: 10, page: params[:page])
    end
    respond_to do |format|
      format.html
      format.odt { list }
    end
  end

  def new
    respond_with(@bapp)
  end

  def create
    @bapp = Bapp.create(bapp_params)
    flash[:notice] = 'Successfully created bapp.' if @bapp.save
    respond_with(@bapp)
  end

  def show
    respond_with(@bapp = Bapp.find(params[:id]))
  end

  def edit
    @bproce_bapp = BproceBapp.new(bapp_id: @bapp.id)
  end

  def update
    @bproce_bapp = BproceBapp.new(bapp_id: @bapp.id)
    if @bapp.update(bapp_params)
      flash[:notice] = 'Successfully updated bapp.'
      respond_with(@bapp)
    else
      render action: 'edit'
    end
  end

  def destroy
    flash[:notice] = 'Successfully destroyed bapp.' if @bapp.destroy
    respond_with(@bapp)
  end

  def autocomplete
    @bapps = Bapp.order(:name).where('description ilike ? or name like ?', "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @bapps.map(&:name)
  end

  def sort_column
    params[:sort] || 'name'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  private

  def bapp_params
    params.require(:bapp).permit(:name, :description, :apptype, :purpose, :version_app,
                                 :directory_app, :distribution_app, :executable_file,
                                 :licence, :source_app, :note, :tag_list)
  end

  def set_app
    if params[:search].present? # это поиск
      @bapps = Bapp.search(params[:search])
                   .order(sort_order(sort_column, sort_direction))
                   .paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @bapp = params[:id].present? ? Bapp.find(params[:id]) : Bapp.new
    end
  end

  def list
    report = ODFReport::Report.new('reports/bapps.odt') do |r|
      nn = 0
      r.add_table('TABLE_01', @bapps, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name, :name)
        t.add_column(:id)
        t.add_column(:description, :description)
        t.add_column(:purpose, :purpose)
        t.add_column(:apptype, :apptype)
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'bapps.odt',
                               disposition: 'inline'
  end
end
