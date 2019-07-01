class ProductItemGroupsController < ApplicationController
  def create
    @origin = set_origin
    @target = set_target
    @form_id = params[:form_id]

    if build_join(@origin, @target)
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    product_swap_sort(@origin, -1)

    respond_to do |format|
      @obj_ref = params[:obj_ref]
      format.js
    end
  end

  def sort_down
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    product_swap_sort(@origin, 1)

    respond_to do |format|
      @obj_ref = params[:obj_ref]
      format.js
    end
  end

  def destroy
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    sort = item_group.sort

    if item_group.destroy
      product_swap_sort_reset_sort(@origin, sort)
      @obj_ref = params[:obj_ref]
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def product_item_group_params
    params.require(:product_item_group).permit!
  end

  def swap_sort(origin_obj, pos)
    sort_obj = ItemGroup.find(params[:id])
    sort = sort_obj.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    #sort_obj2 = origin_obj.item_groups.where(sort: sort2, target_type: sort_obj.target_type)
    sort_obj2 = origin_obj.item_groups.where(sort: sort2)
    sort_obj2.update(sort: sort)
    sort_obj.update(sort: sort2)
  end

  def reset_sort(origin_obj, sort, type)
    grouped_by_type = origin_obj.sti_item_groups(type)
    grouped_by_type.where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end
end
