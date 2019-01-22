class ValueGroupsController < ApplicationController
  def create
    @field = Field.find(params[:field_id]) value_
    @value_group = @field.value_groups.build(value_group_params)
    @form_id = params[:form_id]

    if @value_group.save
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @field = set_parent
    swap_sort(@field, -1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/value_groups/sorter.js.erb"}
    end
  end

  def sort_down
    @field = set_parent
    swap_sort(@field, 1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/value_groups/sorter.js.erb"}
    end
  end

  def destroy
    @field = set_parent
    @value_group = Field.find(params[:id])
    sort = @value_group.sort
    @dom_ref = params[:dom_ref]

    if @value_group.destroy
      reset_sort(@field, sort)

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def value_group_params
    params.require(:value_group).permit!
  end
end
