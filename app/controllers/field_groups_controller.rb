class FieldGroupsController < ApplicationController
  def create
    @fieldable = set_parent
    @field_group = @fieldable.field_groups.build(field_group_params)

    if @field_group.save
      respond_to do |format|
        format.js
      end
    else
    end
  end

  def sort_up
    @fieldable = set_parent
    swap_sort(@fieldable, -1)

    respond_to do |format|
      format.js {render file: "/field_groups/header/sorter.js.erb"}
    end
  end

  def sort_down
    @fieldable = set_parent
    swap_sort(@fieldable, 1)

    respond_to do |format|
      format.js {render file: "/field_groups/header/sorter.js.erb"}
    end
  end

  def destroy
    @fieldable = set_parent
    @field_group = FieldGroup.find(params[:id])
    sort = @field_group.sort

    if @field_group.destroy
      reset_sort(@fieldable, sort)

      respond_to do |format|
        format.js {render file: "/fields/destroy.js.erb"}
      end
    else
    end
  end

  private

  def field_group_params
    params.require(:field_group).permit!
  end
end
