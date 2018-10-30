class ElementsController < ApplicationController
  def create
    @element_kind = ElementKind.find(params[:element_kind_id])
    @element = Element.create(element_params)
    #@element_kind.elements << @element

    if @element.save
      @element_group = @element_kind.element_groups.first
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @element_kind = ElementKind.find(params[:element_kind_id])
    @element = Element.find(params[:id])
    @element.assign_attributes(element_params)

    if @element.save
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @element_kind = ElementKind.find(params[:element_kind_id])
    @element = Element.find(params[:id])
    @element_group = @element_kind.element_groups.first

    if @element.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def element_params
    params.require(:element).permit!
  end
end