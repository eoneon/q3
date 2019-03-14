class ProductPartsController < ApplicationController
  def index
    @product_parts = ProductPart.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='product_parts.xlsx'"}
      format.csv { send_data @product_parts.to_csv }
      format.html
    end
  end

  def show
    @product_part = ProductPart.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @product_part = ProductPart.new(product_part_params)

    if @product_part.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @product_part = ProductPart.find(params[:id])
    @product_part.assign_attributes(product_part_params)

    if @product_part.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @product_part = ProductPart.find(params[:id])

    if @product_part.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  def import
    ProductPart.import(params[:file])
    redirect_to product_kinds_path, notice: 'ProductParts imported.'
  end

  private
  
  def product_part_params
    obj_key = params[:form_id].split('-')[0].to_sym
    params.require(obj_key).permit!
  end
end
