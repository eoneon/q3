class ProductKindsController < ApplicationController
  def index
    @product_kinds = ProductKind.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='product_kinds.xlsx'"}
      format.csv { send_data @product_kinds.to_csv }
      format.html
    end

    def show
      @product_kind = ProductKind.find(params[:id])
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    @product_kind = ProductKind.new(product_kind_params)

    if @product_kind.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @product_kind = ProductKind.find(params[:id])
    @product_kind.assign_attributes(product_kind_params)

    if @product_kind.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @product_kind = ProductKind.find(params[:id])

    if @product_kind.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  def product_kind_params
    params.require(:product_kind).permit!
  end
end
