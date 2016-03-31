# coding: utf-8
class UsersController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:edit, :update, :order]
  before_filter :get_user, :except => [:index, :autocomplete]

  def index
    if params[:role].present?
      @role = Role.find_by(:name => params[:role])
      @users = @role.users.page(params[:page]).active.search(params[:search]).order(sort_column + ' ' + sort_direction)
    else
      if params[:office].present?
        @users = User.active.where(:office => params[:office]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        if params[:all].present?
          @users = User.active.order(sort_column + ' ' + sort_direction)
        else
          if params[:search].present?
            @users = User.page(params[:page]).search(params[:search]).order(sort_column + ' ' + sort_direction)
          else
            @users = User.page(params[:page]).order(sort_column + ' ' + sort_direction)
          end
          #@users, @alphaParams = User.all.alpha_paginate(params[:letter]){|user| user.lastname}
        end
      end
    end
    respond_to do |format|
      format.html
    end
  end

  def autocomplete
    @users = User.active.order(:displayname).where("displayname ilike ?", "%#{params[:term]}%")
    render json: @users.map(&:displayname)
  end

  def show
    #@uroles = @usr.user_business_role.includes(:business_role).order('business_roles.name')   # исполняет роли
    #@uworkplaces = @usr.user_workplace 	# рабочие места пользователя
    #@documents = Document.order(:name).where(owner_id: @usr.id)
    #@contracts = Contract.order('date_begin DESC').where(owner_id: @usr.id)     # договоры, за которые отвечает пользователь
    #@contracts_pay = Contract.order('date_begin DESC').where(payer_id: @usr.id) # договоры, за оплату которых отвечает пользователь
    respond_with()
  end

  def uworkplaces
    @uworkplaces = @usr.user_workplace
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def execute
    @letters = Letter.joins(:user_letter).where("user_letters.user_id = ? and letters.status < 90", @usr.id).order(:duedate, :status)
    @tasks = Task.joins(:user_task).where("user_tasks.user_id = ? and tasks.status < 90", @usr.id).order(:duedate, :status)
    @requirements = Requirement.joins(:user_requirement).where("user_requirements.user_id = ? and requirements.status < 90", @usr.id).order(:duedate, :status)

    respond_to do |format|
      format.html { render layout: false }
    end
  end
  
  def uroles
    @uroles = @usr.user_business_role.includes(:business_role).order('business_roles.name') # исполняет роли
    #- @uworkplaces = @usr.user_workplace # рабочие места пользователя
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def documents
    @documents = Document.order(:name).where(owner_id: @usr.id)
    @user_documents = @usr.document.order('link, updated_at DESC').load  # избранные документы пользователя
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def contracts
    @contracts = Contract.order(:number).where(owner_id: @usr.id)
    @contracts_pay = Contract.order(:number).where(payer_id: @usr.id)
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def resources
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def processes
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def edit
  end

  def update
    if @usr.update_attributes(params[:user])
      redirect_to @usr, notice: "Successfully created user access roles."
    else
      render :edit
    end
  end

  def order   # распоряжение о назначении исполнителей на роли в процессе
    print_order
  end

  def avatar_delete
    @usr.avatar = nil
    flash[:notice] = "Successfully deleted User's avatar." if @usr.save
    redirect_to @usr
  end

  def avatar_create
    render :avatar_create
    #flash[:notice] = "Successfully updated Document's File." if @document.save
  end

  def update_avatar
    ava_file = params[:user][:avatar] if params[:user].present?
    if !ava_file.blank?
      flash[:notice] = 'Изображение "' + ava_file.original_filename  + '" загружено.' if @usr.update_attributes(avatar_params)
    else      
      flash[:alert] = "Ошибка - имя файла не указано."
    end
    redirect_to @usr
  end

  def update_ava
    params[:user][:avatar].each do |key, u|
      if(u[:id] && u[:crop_x] && u[:crop_y] && u[:crop_w] && u[:crop_h])
        old_upload = Upload.find(u[:id].gsub(/D/, '').to_i)
        if(old_upload)
          if(old_upload.update_attributes(u))
            old_upload.reprocess_avatar
          end
        end
      end
    end
    
    respond_to do |format|
      if @usr.update_attributes(params[:user])
        format.html { redirect_to @usr, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @usr.errors, status: :unprocessable_entity }
      end
    end

  end


private

  def avatar_params
    params.require(:user).permit(:avatar)
  end

  # распоряжение о назачении на роли в процессе
  def print_order
    @business_roles = @usr.business_roles.includes(:bproce).order(:name)
    report = ODFReport::Report.new("reports/user-order.odt") do |r|
      r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
      r.add_field :id, @usr.id
      r.add_field "ORDERNUM", Date.today.strftime('%Y%m%d-с') + @usr.id.to_s
      r.add_field :displayname, @usr.displayname
      r.add_field :position, @usr.position
      rr = 0
      r.add_table("ROLES", @business_roles, :header => false, :skip_if_empty => true) do |t|
        t.add_column(:rr) do |n1| # порядковый номер строки таблицы
          rr += 1
        end
        t.add_column(:nr, :name)
        t.add_column(:rdescription, :description)
        t.add_column(:process_name) do |bp|
          bp.bproce.name
        end
        t.add_column(:process_id) do |bp|
          bp.bproce.id
        end
      end
      r.add_field "USER_POSITION", current_user.position
      r.add_field "USER_NAME", current_user.displayname
    end
    send_data report.generate, type: 'application/msword',
      :filename => "u#{@usr.id}-order-#{Date.current.strftime('%Y%m%d')}.odt",
      :disposition => 'inline'
  end

  def sort_column
    params[:sort] || "displayname"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def get_user
    if params[:search].present? # это поиск
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
      render :index # покажем список найденного
    else
      @usr = params[:id].present? ? User.find(params[:id]) : User.new
    end
  end

end
