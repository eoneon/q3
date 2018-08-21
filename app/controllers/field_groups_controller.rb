class FieldGroupsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @field_group = @category.field_groups.build(field_group_params)

    if @field_group.save
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
    field = Field.find(params[:id])
    field_group = @category.field_groups.find_by(field_id: params[:id])

    if field_group.destroy
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
end
