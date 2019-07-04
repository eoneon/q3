class ProductItemGroupsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    target = helpers.obj_assocs(@product).detect {|assoc_name| params[:item_group][:"#{assoc_name}_id"].present?}
    target = helpers.to_konstant(target).find(params[:item_group][:"#{target}_id"])

    if build_join(@product, target)
      @form_id = params[:form_id]
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
      format.js {render file: "/product_item_groups/sorter.js.erb"}
    end
  end

  def sort_down
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target
    product_swap_sort(@origin, 1)

    respond_to do |format|
      @obj_ref = params[:obj_ref]
      format.js {render file: "/product_item_groups/sorter.js.erb"}
    end
  end

  def destroy
    item_group = ItemGroup.find(params[:id])
    @origin = item_group.origin
    @target = item_group.target

    if item_group.target_type == 'ProductKind'
      @origin.item_groups.destroy_all
    else
      sort = item_group.sort
      item_group.destroy
      product_reset_sort(@origin, sort)
    end

     respond_to do |format|
       format.js
     end
  end

  private

  def product_item_group_params
    params.require(:item_group).permit!
  end

  def product_swap_sort(origin_obj, pos)
    sort_obj = ItemGroup.find(params[:id])
    sort = sort_obj.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    sort_obj2 = origin_obj.item_groups.where(sort: sort2)
    sort_obj2.update(sort: sort)
    sort_obj.update(sort: sort2)
  end

  def product_reset_sort(origin_obj, sort)
    origin_obj.item_groups.where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end
end
