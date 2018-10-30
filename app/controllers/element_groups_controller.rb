class ElementGroupsController < ApplicationController
  def create
    @elementable = set_parent
    @element_group = @elementable.element_groups.build(element_group_params)

    if @element_group.save
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @elementable = set_parent
    swap_sort(@elementable, -1)

    respond_to do |format|
      format.js {render file: "/element_groups/header/sorter.js.erb"}
    end
  end

  def sort_down
    @elementable = set_parent
    swap_sort(@elementable, 1)

    respond_to do |format|
      format.js {render file: "/element_groups/header/sorter.js.erb"}
    end
  end

  def destroy
    @elementable = set_parent
    @element_group = ElementGroup.find(params[:id])
    sort = @element_group.sort

    if @element_group.destroy
      reset_sort(@elementable, sort)

      respond_to do |format|
        format.js {render file: "/element_kinds/destroy.js.erb"}
      end
    end
  end

  private

  def element_group_params
    params.require(:element_group).permit!
  end
end
