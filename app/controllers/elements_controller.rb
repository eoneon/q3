class ElementsController < ApplicationController
  def index
    if params[:element] && params[:element][:search]
      @elements = Element.option_group_set(params[:element][:search])
    else
      #@elements = Element.all
      #@elements = Element.origin_class
      @elements = Element.option_group
      #@elements = Element.option_key
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
