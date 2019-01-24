class ValueGroupsController < ApplicationController
  def create
    @field = Field.find(params[:field_id])
    @value_group = @field.value_groups.build(value_group_params)

    if @value_group.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @field = Field.find(params[:field_id])
    swap_sort(@field, -1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/value_groups/sorter.js.erb"}
    end
  end

  def sort_down
    @field = Field.find(params[:field_id])
    swap_sort(@field, 1)

    respond_to do |format|
      @dom_ref = params[:dom_ref]
      format.js {render file: "/value_groups/sorter.js.erb"}
    end
  end

  def destroy
    @field = Field.find(params[:field_id]) 
    @value_group = ValueGroup.find(params[:id])
    sort = @value_group.sort

    if @value_group.destroy
      reset_sort(@field, sort)
      @dom_ref = params[:dom_ref]

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
