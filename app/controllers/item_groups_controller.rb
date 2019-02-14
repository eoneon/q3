class ItemGroupsController < ApplicationController
  def create
    @origin = set_origin
    @target = set_target

    if build_join(@origin, @target)
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  # def sort_up
  #   @left_item = set_parent
  #   swap_sort(@left_item, -1)
  #   @dom_ref = params[:dom_ref]
  #
  #   respond_to do |format|
  #     format.js {render file: "/item_groups/sorter.js.erb"}
  #   end
  # end
  #
  # def sort_down
  #   @left_item = set_parent
  #   swap_sort(@left_item, 1)
  #   @dom_ref = params[:dom_ref]
  #
  #   respond_to do |format|
  #     format.js {render file: "/item_groups/sorter.js.erb"}
  #   end
  # end

  def destroy
    @left_item = set_parent
    @item_group = ElementGroup.find(params[:id])
    sort = @item_group.sort
    @dom_ref = params[:dom_ref]

    if @item_group.destroy
      reset_sort(@left_item, sort)

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
