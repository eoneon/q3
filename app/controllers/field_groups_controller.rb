class FieldGroupsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    field_group = @category.field_groups.build(field_group_params)
    set_sort(@category, field_group)

    if field_group.save
      flash[:notice] = "Field chain was saved successfully."
      redirect_to @category
    else
      flash.now[:alert] = "Error creating Field chain. Please try again."
      redirect_to @category
    end
  end

  def sort_up
    @category = Category.find(params[:category_id])
    swap_sort(@category, -1)
    redirect_to @category
  end

  def sort_down
    @category = Category.find(params[:category_id])
    swap_sort(@category, 1)
    redirect_to @category
  end

  def destroy
    @category = Category.find(params[:category_id])
    field_group = @category.field_groups.find_by(field_id: params[:id])
    sort = field_group.sort

    if field_group.destroy
      reset_sort(@category, sort)
      flash[:notice] = "Field chain was deleted successfully."
      redirect_to @category
    else
      flash.now[:alert] = "There was an error deleting the Field chain."
      redirect_to @category
    end
  end

  private

  def field_group_params
    params.require(:field_group).permit!
  end

  def set_sort(category, field_group)
    field_group.sort = category.sorted_field_groups.count == 0 ? 1 : category.sorted_field_groups.count + 1
  end

  def reset_sort(category, sort)
    category.field_groups.where("sort > ?", sort).each do |field|
      field.update(sort: field.sort - 1)
    end
  end

  # def swap_sort(category, sort, sib_sort)
  #   field = category.field_groups.where(sort: sib_sort)
  #   field.update(sort: sort)
  # end

  def swap_sort(category, pos)
    field_group = @category.field_groups.find_by(field_id: params[:id])
    sort = field_group.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    field_group2 = @category.field_groups.where(sort: sort2)
    field_group2.update(sort: sort)
    field_group.update(sort: sort2)
  end
end
