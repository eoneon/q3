 class ValuesController < ApplicationController
  def index
    @values = Value.all
    respond_to do |format|
      format.html
      format.csv { send_data @values.to_csv }
      #format.xls { send_data @values.to_csv(col_sep: "\t") }
    end
  end

  def show
    @value = Value.find(params[:id])
  end

  def new
    @field = Field.find(params[:field_id])
    @value = Value.new
  end

  def edit
    @value = Value.find(params[:id])
  end

  def create
    @field = Field.find(params[:field_id])
    @value = @field.values.build(value_params)

    if @value.save
      @field_group = @field.field_groups.first
    else
      #flash.now[:alert] = "Error creating Value. Please try again."
    end
    #render :edit
    respond_to do |format|
      #format.html
      format.js
    end
  end

  def update
    field = Field.find(params[:field_id])
    @value = Value.find(params[:id])
    @value.assign_attributes(value_params)

    if @value.save
      @field_group = field.field_groups.first
    else
      #flash.now[:alert] = "Error updated value. Please try again."
      #render :edit
    end

    respond_to do |format|
      #format.html
      format.js
    end
  end

  def destroy
    @value = Value.find(params[:id])
    field = @value.field

    if @value.destroy
      @field_group = field.field_groups.first
    else
    end

    respond_to do |format|
      format.js
    end
  end

  def import
    Value.import(params[:file])
    redirect_to values_path, notice: 'Field Values imported.'
  end

  private

  def value_params
    params.require(:value).permit!
  end
end
