class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='categories.xlsx'"}
      format.csv { send_data @categories.to_csv }
      format.html
    end
  end

  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.assign_attributes(category_params)

    if @category.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      respond_to do |format|
        format.js
      end
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
