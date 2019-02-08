class ElementsController < ApplicationController
  def index
    @elements = Element.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='elements.xlsx'"}
      format.csv { send_data @elements.to_csv }
      format.html
    end
  end

  def create
    # @element_kind = ElementKind.find(params[:element_kind_id])
    # @element = @element_kind.elements.build(element_params)
    # @element_kind.elements << @element

    @poly_element = set_parent
    @element = @poly_element.elements.build(element_params)
    @poly_element.elements << @element

    if @element.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    # @element_kind = ElementKind.find(params[:element_kind_id])
    # @element = Element.find(params[:id])
    # @element.assign_attributes(element_params)
    # @form_id = params[:form_id]

    @poly_element = set_parent
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
    @poly_element = set_parent
    swap_sort(@poly_element, -1)
    @dom_ref = params[:dom_ref]
    @element_join = @poly_element.element_joins.first

    respond_to do |format|
      format.js {render file: "/elements/sorter.js.erb"}
    end
  end

  def sort_down
    @poly_element = set_parent
    swap_sort(@poly_element, 1)
    @dom_ref = params[:dom_ref]
    @element_join = @poly_element.element_joins.first

    respond_to do |format|
      format.js {render file: "/elements/sorter.js.erb"}
    end
  end

  def destroy
    @element_kind = ElementKind.find(params[:element_kind_id])
    @element = Element.find(params[:id])
    @element_join = @element_kind.element_joins.first

    if @element.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  def import
    Element.import(params[:file])
    redirect_to elements_path, notice: 'Elements imported.'
  end

  private

  def element_params
    params.require(:element).permit!
  end
end
