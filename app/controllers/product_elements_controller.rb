class ProductElementsController < ApplicationController
  def index
    if params[:product_element] && params[:product_element][:search]
      @products = Element.product_search(params[:product_element][:search])
    else
      @products = Element.by_kind('product')
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

  def product_element_params
    params.require(:product_element).permit!(:search)
  end
end
