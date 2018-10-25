class DimensionsController < ApplicationController
  def index
    @dimensions = Dimension.all.order(sort: 'asc')

    respond_to do |format|
      format.html
      format.csv { send_data @dimensions.to_csv(['sort', 'name']), filename: "Dimensions.csv" }
      format.xls { send_data @dimensions.to_csv(['sort', 'name'], col_sep: "\t") }
    end
  end

  def create
    @category = Category.find(params[:category_id])
    @categorizable = Dimension.create(dimension_params)

    @category.dimensions << @categorizable

    if @category.save
      @sub_category = @categorizable.sub_categories.first

      respond_to do |format|
        format.js {render file: "/categorizables/create.js.erb"}
      end
    else
    end
  end

  def update
    @category = Category.find(params[:category_id])
    @categorizable = Dimension.find(params[:id])
    @categorizable.assign_attributes(dimension_params)

    if @categorizable.save
    else
    end

    respond_to do |format|
      format.js {render file: "/categorizables/update.js.erb"}
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @categorizable = Dimension.find(params[:id])
    @sub_category = @categorizable.sub_categories.first
    
    if @categorizable.destroy

    else
    end
    respond_to do |format|
      format.js {render file: "/categorizables/destroy.js.erb"}
    end
  end

  def import
    Dimension.import(params[:file])
    redirect_to dimensions_path, notice: 'Dimensions imported.'
  end

  private

  def dimension_params
    params.require(:dimension).permit!
  end
end
