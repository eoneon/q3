class ElementsController < ApplicationController
  def index
    #@elements = Element.product_search(params[:element][:search])
    if params[:element] && params[:element][:search]
      @elements = Element.product_search(params[:element][:search])
    else
      @elements = Element.by_kind('product')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @element = Element.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private

  def element_params
    params.require(:element).permit!(:search)
  end
end
