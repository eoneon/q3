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

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category was saved successfully."
      redirect_to @category
    else
      flash.now[:alert] = "Error creating Category. Please try again."
      render :edit
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
    #render :edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:notice] = "\"#{@category.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the category."
      render :show
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
