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

  def update
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

  def siblings(category)
    category.fields
  end

  def max_sort(category)
    siblings(category).count
  end

  def set_sort(category, field_group)
    field_group.sort = max_sort(category) == 0 ? 1 : max_sort(category) + 1
  end

  def reset_sort(category, sort)
    category.field_groups.where("sort > ?", sort).each do |field|
      field.update(sort: field.sort - 1)
    end
  end
end
