class SubCategoriesController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build(sub_category_params)
    #set_sort(@category, @sub_category)

    if @sub_category.save
      @categorizable = @sub_category.categorizable

      respond_to do |format|
        format.js
      end
    else
    end
  end

  def sort_up
    @category = Category.find(params[:category_id])
    swap_sort(@category, -1)

    respond_to do |format|
      format.js {render file: "/sub_categories/sorter.js.erb"}
    end
  end

  def sort_down
    @category = Category.find(params[:category_id])
    swap_sort(@category, 1)

    respond_to do |format|
      format.js {render file: "/sub_categories/sorter.js.erb"}
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @sub_category = SubCategory.find(params[:id])
    @categorizable = @sub_category.categorizable
    sort = @sub_category.sort

    if @sub_category.destroy
      reset_sort(@category, sort)
      @category = Category.find(params[:category_id])

      respond_to do |format|
        format.js {render file: "/categorizables/destroy.js.erb"}
      end
    else
    end
  end

  private

  def sub_category_params
    params.require(:sub_category).permit!
  end
end
