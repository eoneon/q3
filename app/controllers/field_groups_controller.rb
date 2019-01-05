class FieldGroupsController < ApplicationController
  def create
    @fieldable = set_parent
    @field_group = @fieldable.field_groups.build(field_group_params)
    @form_id = params[:form_id]

    if @field_group.save
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @fieldable = set_parent
    swap_sort(@fieldable, -1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/field_groups/sorter.js.erb"}
    end
  end

  def sort_down
    @fieldable = set_parent
    swap_sort(@fieldable, 1)
    @dom_ref = params[:dom_ref]

    respond_to do |format|
      format.js {render file: "/field_groups/sorter.js.erb"}
    end
  end

  def destroy
    @fieldable = set_parent
    @field_group = FieldGroup.find(params[:id])
    sort = @field_group.sort
    @dom_ref = params[:dom_ref]

    if @field_group.destroy
      reset_sort(@fieldable, sort)

      respond_to do |format|
        format.js {render file: "/fields/destroy.js.erb"}
      end
    end
  end

  private

  def field_group_params
    params.require(:field_group).permit!
  end
end
