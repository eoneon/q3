class ElementsController < ApplicationController
  def create
    @element_kind = ElementKind.find(params[:element_kind_id])
    @element = @element_kind.elements.build(element_params)
    @form_id = params[:form_id]
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
    @form_id = params[:form_id]

    if @element.save
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @element_kind = set_parent
    swap_sort(@element_kind, -1)
    @dom_ref = params[:dom_ref]
    @element_group = @element_kind.element_groups.first

    respond_to do |format|
      format.js {render file: "/elements/sorter.js.erb"}
    end
  end

  def sort_down
    @element_kind = set_parent
    swap_sort(@element_kind, 1)
    @dom_ref = params[:dom_ref]
    @element_group = @element_kind.element_groups.first

    respond_to do |format|
      format.js {render file: "/elements/sorter.js.erb"}
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
