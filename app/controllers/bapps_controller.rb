# frozen_string_literal: true

class BappsController < ApplicationController
  respond_to :html
  respond_to :pdf, :odf, :xml, :json, only: :index
  helper_method :sort_column, :sort_direction
  before_action :set_app, except: %i[index print]
  before_action :authenticate_user!, only: %i[edit new]

  autocomplete :bproce, :name, extra_data: [:id]

  def index
    if params[:bproce_id].present? # это приложения выбранного процесса
      @bp = Bproce.find(params[:bproce_id]) # информация о процессе
      @bproce_bapps = @bp.bproce_bapps.paginate(per_page: 10, page: params[:page])
    elsif params[:all].present?
      @bapps = Bapp.all
    elsif params[:apptype].present?
      @bapps = Bapp.searchtype(params[:apptype]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
    elsif params[:tag].present?
      @bapps = Bapp.tagged_with(params[:tag]).search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
    else
      @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
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
    @bapp = Bapp.create(params[:bapp])
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
    if @bapp.update_attributes(params[:bapp])
      flash[:notice] = 'Successfully updated bapp.' if @bapp.update_attributes(params[:bapp])
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

  def set_app
    if params[:search].present? # это поиск
      @bapps = Bapp.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @bapp = params[:id].present? ? Bapp.find(params[:id]) : Bapp.new
    end
  end

  def list
    report = ODFReport::Report.new('reports/bapps.odt') do |r|
      nn = 0
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_table('TABLE_01', @bapps, header: true) do |t|
        t.add_column(:nn) do |_ca|
          nn += 1
          "#{nn}."
        end
        t.add_column(:name, :name)
        t.add_column(:description, :description)
        t.add_column(:purpose, :purpose)
        t.add_column(:apptype, :apptype)
      end
      r.add_field 'USER_POSITION', current_user.position
      r.add_field 'USER_NAME', current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
                               filename: 'documents.odt',
                               disposition: 'inline'
  end
end
