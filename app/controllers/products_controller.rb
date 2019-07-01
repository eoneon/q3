class ProductsController < ApplicationController
  def index
    @products = Product.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='products.xlsx'"}
      format.csv { send_data @products.to_csv }
      format.html
    end
  end

  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @product = Product.new(product_params)
    @products = Product.all
    if @product.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.assign_attributes(product_params)

    if @product.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])

    if @product.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  # def import
  #   Product.import(params[:file])
  #   redirect_to products_path, notice: 'Products imported.'
  # end

  private

  def product_params
    params.require(:product).permit!
  end
end
