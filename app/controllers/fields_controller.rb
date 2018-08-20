class FieldsController < ApplicationController
  def index
    @fields = Field.all
    respond_to do |format|
      format.html
      format.csv { send_data @fields.to_csv }
      #format.xls { send_data @fields.to_csv(col_sep: "\t") }
    end
  end

  def show
    @field = Field.find(params[:id])
  end

  def new
    #@category = Category.find(params[:category_id]) if params[:category_id]
    @field = Field.new
  end

  def edit
    @field = Field.find(params[:id])
  end

  def create
    @field = Field.new(field_params)

    if @field.save
      flash[:notice] = "Field was saved successfully."
      render :edit
    else
      flash.now[:alert] = "Error creating Field. Please try again."
      render :new
    end
  end

  def update
    @field = Field.find(params[:id])
    @field.assign_attributes(field_params)

    if @field.save
      flash[:notice] = "field was updated successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "Error updated field. Please try again."
      render :edit
    end
  end

  def destroy
    @field = Field.find(params[:id])

    if @field.destroy
      flash[:notice] = "\"#{@field.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the field."
      render :show
    end
  end

  def import
    Field.import(params[:file])
    redirect_to fields_path, notice: 'Fields imported.'
  end

  private

  def field_params
    params.require(:field).permit!
  end
end
