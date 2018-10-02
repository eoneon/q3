class SubCategoriesController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build(sub_category_params)
    #set_sort(@category, @sub_category)

    if @sub_category.save
      respond_to do |format|
        format.html
        format.js
      end
    else
    end
  end

  def sort_up
    @category = Category.find(params[:category_id])
    swap_sort(@category, -1)
    #redirect_to @category
  end

  def sort_down
    @category = Category.find(params[:category_id])
    swap_sort(@category, 1)
    #redirect_to @category
  end

  def destroy
    @category = Category.find(params[:category_id])
    sub_category = SubCategory.find(params[:id])
    sort = sub_category.sort

    if sub_category.destroy
      reset_sort(@category, sort)
      #flash[:notice] = "Field chain was deleted successfully."
      #redirect_to @category
    else
      #flash.now[:alert] = "There was an error deleting the Field chain."
      #redirect_to @category
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def sub_category_params
    params.require(:sub_category).permit!
  end

  # def set_sort(category, sub_category)
  #   sub_category.sort = category.sorted_sub_categories.count == 0 ? 1 : category.sorted_sub_categories.count + 1
  # end

  # def reset_sort(category, sort)
  #   category.sub_categories.where("sort > ?", sort).each do |sub_category|
  #     sub_category.update(sort: sub_category.sort - 1)
  #   end
  # end

  # def swap_sort(category, pos)
  #   sub_category = SubCategory.find(params[:id])
  #   sort = sub_category.sort
  #   sort2 = pos == -1 ? sort - 1 : sort + 1
  #
  #   sub_category2 = category.sub_categories.where(sort: sort2)
  #   sub_category2.update(sort: sort)
  #   sub_category.update(sort: sort2)
  # end
end
