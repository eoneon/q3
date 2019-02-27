class ProductPartsController < ApplicationController
  def index
    @product_parts = ProductPart.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='product_parts.xlsx'"}
      format.csv { send_data @product_parts.to_csv }
      format.html
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
end
