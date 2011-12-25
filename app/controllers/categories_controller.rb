class CategoriesController < ApplicationController
  respond_to :html, :xml, :json
  helper_method :sort_column, :sort_direction

  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  def show
    respond_with(@category = Category.find(params[:id]))
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    flash[:notice] = "Successfully updated category."  if @category.update_attributes(params[:category])
    respond_with(@category)
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destriyed category."  if @category.save
    respond_with(@category)
  end
end
