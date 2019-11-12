class ProductsController < ApplicationController
  def index
    if params[:product] && params[:product][:search]
      @products = Element.search(params[:product][:search])
    else
      @products = Element.products# .order("tags -> 'embellished'")
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @product = Element.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private

  def product_params
    params.require(:product).permit!(:search)
  end
end
