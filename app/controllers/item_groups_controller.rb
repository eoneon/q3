class ItemGroupsController < ApplicationController
  def create
    @origin = set_origin
    @target = set_target
    @form_id = params[:form_id]

    if build_join(@origin, @target)
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/create.js.erb"}
      end
    end
  end

  def sort_up
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    swap_sort(@origin, -1)

    respond_to do |format|
      @obj_ref = params[:obj_ref]
      format.js {render file: "/#{render_filepath}/sorter.js.erb"}
    end
  end

  def sort_down
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    swap_sort(@origin, 1)

    respond_to do |format|
      @obj_ref = params[:obj_ref]
      format.js {render file: "/#{render_filepath}/sorter.js.erb"}
    end
  end

  def destroy
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    sort = item_group.sort
    type = item_group.target_type

    if item_group.destroy
      reset_sort(@origin, sort, type)
      @obj_ref = params[:obj_ref]
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/destroy.js.erb"}
      end
    end
  end

  private

  def item_group_params
    params.require(:item_group).permit!
  end
end
