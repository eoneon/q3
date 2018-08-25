class DimensionsController < ApplicationController
  def index
    @dimensions = Dimension.all.order(sort: 'asc')

    respond_to do |format|
      format.html
      format.csv { send_data @dimensions.to_csv(['sort', 'name']), filename: "Dimensions.csv" }
      format.xls { send_data @dimensions.to_csv(['sort', 'name'], col_sep: "\t") }
    end
  end

  def show
    @dimension = Dimension.find(params[:id])
  end

  def new
    @dimension = Dimension.new
  end

  def edit
    @dimension = Dimension.find(params[:id])
  end

  def create
    @dimension = Dimension.new(dimension_params)

    if @dimension.save
      flash[:notice] = "Dimension was saved successfully."
      redirect_to @dimension
    else
      flash.now[:alert] = "Error creating Dimension. Please try again."
      render :edit
    end
  end

  def update
    @dimension = Dimension.find(params[:id])
    @dimension.assign_attributes(dimension_params)

    if @dimension.save
      flash[:notice] = "Dimension was updated successfully."
    else
      flash.now[:alert] = "Error updated dimension. Please try again."
    end
    render :edit
  end

  def destroy
    @dimension = Dimension.find(params[:id])

    if @dimension.destroy
      flash[:notice] = "\"#{@dimension.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the dimension."
      render :show
    end
  end

  def import
    Dimension.import(params[:file])
    redirect_to dimensions_path, notice: 'Categories imported.'
  end

  private

  def dimension_params
    params.require(:dimension).permit!
  end
end
