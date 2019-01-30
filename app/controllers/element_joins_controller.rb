class ElementJoinsController < ApplicationController
  def create
    @poly_element = set_parent
    @element_join = @poly_element.element_joins.build(element_join_params)
    @poly_element.element_joins << @element_join

    if @element_join.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @poly_element = set_parent
    swap_sort(@poly_element, -1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/element_joins/sorter.js.erb"}
    end
  end

  def sort_down
    @poly_element = set_parent
    swap_sort(@poly_element, 1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/element_joins/sorter.js.erb"}
    end
  end

  def destroy
    @poly_element = set_parent
    @element_join = ElementJoin.find(params[:id])
    sort = @element_join.sort
    @dom_ref = params[:dom_ref]

    if @element_join.destroy
      reset_sort(@poly_element, sort)

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def element_join_params
    params.require(:element_join).permit!
  end
end
