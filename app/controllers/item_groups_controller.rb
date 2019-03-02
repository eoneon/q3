class ItemGroupsController < ApplicationController
  def create
    @origin = set_origin
    @target = set_target

    @form_id = params[:form_id]

    #if build_join(@origin, @target)
    if @origin.public_send(@target.class.name.underscore.pluralize) << @target
      #@item_group = ItemGroup.find(params[:item_group_id])

      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    swap_sort(@origin, -1)

    respond_to do |format|
      format.js {render file: "/item_groups/sorter.js.erb"}
    end
  end

  def sort_down
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    swap_sort(@origin, 1)

    respond_to do |format|
      format.js {render file: "/item_groups/sorter.js.erb"}
    end
  end

  def destroy
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    sort = item_group.sort

    if item_group.destroy
      reset_sort(@origin, sort)

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def item_group_params
    params.require(:item_group).permit!
  end
end
