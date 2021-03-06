# frozen_string_literal: true

class UsersController < ApplicationController
  include Reports

  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, only: %i[edit update order move_to stop_all]
  before_action :find_user, except: %i[index autocomplete]

  def index
    if params[:role].present?
      @role = Role.find_by(name: params[:role])
      users = @role.users.active.search(params[:search])
    elsif params[:office].present?
      users = User.active.where(office: params[:office])
    elsif params[:all].present?
      users = User.active
    else
      users = if params[:search].present?
                User.search(params[:search])
              else
                User.all
              end
      # @users, @alphaParams = User.all.alpha_paginate(params[:letter]){|user| user.lastname}
    end
    @users = users.page(params[:page]).order(sort_order(sort_column, sort_direction))
  end

  def autocomplete
    @users = User.active.order(:displayname).where('displayname ilike ?', "%#{params[:term]}%")
    render json: @users.map(&:displayname)
  end

  def show; end

  def uworkplaces
    @uworkplaces = @usr.user_workplace
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def execute
    @letters_ids = Letter.joins(:user_letter).where('user_letters.user_id = ? and letters.status < 90', @usr.id).ids # \
    # | Letter.where("author_id = ? and status < 90", @usr.id).ids
    @letters = Letter.where(id: @letters_ids).order(:duedate, :status)
    @tasks_ids = Task.joins(:user_task).where('user_tasks.user_id = ? and tasks.status < 90', @usr.id).ids \
               | Task.where('author_id = ? and status < 90', @usr.id).ids
    @tasks = Task.where(id: @tasks_ids).order(:duedate, :status)
    @requirements_ids = Requirement.joins(:user_requirement)
                                   .where('user_requirements.user_id = ? and requirements.status < 90', @usr.id).ids \
                      | Requirement.where('author_id = ? and status < 90', @usr.id).ids
    @requirements = Requirement.where(id: @requirements_ids).order(:duedate, :status)

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def uroles
    @uroles = @usr.user_business_role.includes(:business_role).order('business_roles.name') # исполняет роли
    #- @uworkplaces = @usr.user_workplace # рабочие места пользователя
    # p params[:layout]
    respond_to do |format|
      if params[:layout].present?
        format.html { render layout: true }
      else
        format.html { render layout: false }
      end
    end
  end

  def documents
    @documents = Document.order(:name).where(owner_id: @usr.id)
    # @user_documents = @usr.document.order('link, updated_at DESC').load # избранные документы пользователя
    ids = UserDocument.where(user_id: @usr.id).pluck :document_id # избранные документы пользователя
    @user_documents = Document.where(id: ids).all
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def contracts
    contracts = Contract.where(status: 'Действует').includes(:agent, :contract_scan).order(:number)
    @contracts = contracts.where(owner_id: @usr.id).includes(:agent, :contract_scan).order(:number)
    @contracts_pay = Contract.where(payer_id: @usr.id).includes(:agent, :contract_scan).order(:number)
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

  def edit; end

  def move_to
    @old_user = User.find(params[:id])
    @new_user = User.new
    render :move_to
  end

  def business_roles_move_to
    user_name = params[:user][:user_name]
    new_user = User.find_by(displayname: user_name)
    UserBusinessRole.where(user_id: @usr.id).find_each do |user_role|
      user_role.user_id = new_user.id
      user_role.note += " (#{@usr.displayname})"
      user_role.save
    end
    render :edit
  end

  def copy_to
    @old_user = User.find(params[:id])
    @new_user = User.new
    render :copy_to
  end

  def business_roles_copy_to
    user_name = params[:user][:user_name]
    new_user = User.find_by(displayname: user_name)
    UserBusinessRole.where(user_id: @usr.id).find_each do |user_role|
      user_role.note += " (#{@usr.displayname})"
      unless UserBusinessRole.where(user_id: new_user.id, business_role_id: user_role.business_role_id).any?
        UserBusinessRole.create(user_id: new_user.id,
                                business_role_id: user_role.business_role_id,
                                date_from: Time.current,
                                note: "#{user_role.note} +(#{@usr.displayname})")
      end
    end
    render :edit
  end

  def stop_all
    UserBusinessRole.where(user_id: @usr.id).each(&:destroy)
    render :edit
  end

  def move_documents_to
    @old_user = User.find(params[:id])
    @new_user = User.new
  end

  def documents_move_to
    user_name = params[:user][:user_name]
    new_user = User.find_by(displayname: user_name)
    Document.where(owner_id: @usr.id).find_each do |document|
      document.update! owner_id: new_user.id
    end
    redirect_to new_user, notice: 'Документы переданы новому ответственному'
  end

  def update
    if @usr.update(user_params)
      redirect_to @usr, notice: 'Successfully created user access roles.'
    else
      render :edit
    end
  end

  def order
    print_order # распоряжение о назначении исполнителей на роли в процессе
  end

  def pass
    print_pass # печать пропуска
  end

  def avatar_delete
    @usr.avatar = nil
    flash[:notice] = "Successfully deleted User's avatar." if @usr.save
    redirect_to @usr
  end

  def avatar_create
    render :avatar_create
    # flash[:notice] = "Successfully updated Document's File." if @document.save
  end

  def update_avatar
    ava_file = params[:user][:avatar] if params[:user].present?
    if ava_file.present?
      flash[:notice] = 'Изображение "' + ava_file.original_filename + '" загружено.' if @usr.update(avatar_params)
    else
      flash[:alert] = 'Ошибка - имя файла не указано.'
    end
    redirect_to @usr
  end

  def update_ava
    params[:user][:avatar].find_each do |_key, u|
      if u[:id] && u[:crop_x] && u[:crop_y] && u[:crop_w] && u[:crop_h]
        old_upload = Upload.find(u[:id].delete('D').to_i)
        if old_upload
          old_upload.reprocess_avatar if old_upload.update(u)
        end
      end
    end

    respond_to do |format|
      if @usr.update(params[:user])
        format.html { redirect_to @usr, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @usr.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name) # , :office, :email,
    # :encrypted_password, :last_sign_in_at, :created_at, :updated_at, :firstname, :lastname, :username, :displayname)
  end

  def avatar_params
    params.require(:user).permit(:avatar)
  end

  # распоряжение о назачении на роли в процессе
  def print_order
    @business_roles = @usr.business_roles.includes(:bproce).order(:name)
    report = ODFReport::Report.new('reports/user-order.odt') do |r|
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_field :id, @usr.id
      r.add_field 'ORDERNUM', Date.current.strftime('%Y%m%d-с') + @usr.id.to_s
      r.add_field :displayname, @usr.displayname
      r.add_field :position, @usr.position
      rr = 0
      r.add_table('ROLES', @business_roles, header: false, skip_if_empty: true) do |t|
        t.add_column(:rr) do |_n1| # порядковый номер строки таблицы
          rr += 1
        end
        t.add_column(:nr, :name)
        t.add_column(:rdescription, :description)
        t.add_column(:br_note) do |br|
          br.features || ''
        end
        t.add_column(:process_name) do |bp|
          bp.bproce.name
        end
        t.add_column(:process_id) do |bp|
          bp.bproce.id
        end
      end
      report_footer r
    end
    send_data report.generate, type: 'application/msword',
                               filename: "u#{@usr.id}-order-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  # распоряжение о назачении на роли в процессе
  def print_pass
    report = ODFReport::Report.new('reports/user-pass.odt') do |r|
      r.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
      r.add_field :id, @usr.id
      r.add_field 'REPORT_DATE_TIME', Time.current.strftime('%d.%m.%Y %H:%M')
      r.add_field :lastname, @usr.lastname
      r.add_field :firstname, @usr.firstname
      r.add_field :middlename, @usr.middlename
      r.add_field :position, @usr.position
    end
    send_data report.generate, type: 'application/msword',
                               filename: "u#{@usr.id}-pass-#{Date.current.strftime('%Y%m%d')}.odt",
                               disposition: 'inline'
  end

  def sort_column
    params[:sort] || 'displayname'
  end

  def sort_direction
    params[:direction] || 'asc'
  end

  def find_user
    if params[:search].present? # это поиск
      @users = User.search(params[:search])
                   .order(sort_order(sort_column, sort_direction))
                   .paginate(per_page: 10, page: params[:page])
      render :index # покажем список найденного
    else
      @usr = params[:id].present? ? User.find(params[:id]) : User.new
    end
  end
end
