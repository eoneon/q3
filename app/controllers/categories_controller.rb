class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(sort: 'asc')
    @category = @categories.first

    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @categories.to_csv(['sort', 'name']), filename: "Categories.csv" }
    #   format.xls { send_data @categories.to_csv(['sort', 'name'], col_sep: "\t") }
    # end
  end

  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # def new
  #   @category = Category.new
  # end
  #
  # def edit
  #   @category = Category.find(params[:id])
  # end

  def create
    @category = Category.new(category_params)

    if @category.save
      @categories = Category.all.order(sort: 'asc')
      respond_to do |format|
        format.html
        format.js
      end
    else
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.assign_attributes(category_params)

    if @category.save
      @categories = Category.all.order(sort: 'asc')
    else
      flash.now[:alert] = "Error updated category. Please try again."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    category = Category.find(params[:id])

    if category.destroy
      @categories = Category.all.order(sort: 'asc')
      @category = @categories.first
    else
    end

    respond_to do |format|
      format.js
    end
  end

  def import
    Category.import(params[:file])
    redirect_to categories_path, notice: 'Categories imported.'
  end

  private

  def category_params
    params.require(:category).permit!
  end
end
